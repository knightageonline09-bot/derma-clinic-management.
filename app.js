const toast = document.getElementById('toast');
const modal = document.getElementById('modal');
const sidebar = document.getElementById('sidebar');
const pageLabel = document.getElementById('pageLabel');
const loginScreen = document.getElementById('loginScreen');
const appShell = document.getElementById('appShell');
const loginError = document.getElementById('loginError');
// Per tab, not per origin. localStorage is shared by every tab of the origin, so signing in as a
// second role in a second tab overwrote the first tab's session, and refreshing that first tab
// restored whichever role had signed in last anywhere. sessionStorage is scoped to the tab and
// survives a refresh within it, which is the behaviour this needs: a Receptionist tab and an Inventory
// Staff tab can be open side by side and each keeps its own role, and its own tokens.
const sessionKey = 'dermaClinicSession';
// The previous key outlived the fix and sat in shared storage holding a full session, tokens
// included. It is cleared on load below so an existing browser does not keep that copy around.
const legacySessionKey = 'dermaClinicDemoSession';
const apiBaseUrl = 'http://localhost:8080';
const roleLabels = {
  ADMINISTRATOR: 'Administrator',
  RECEPTIONIST: 'Receptionist',
  DERMATOLOGIST: 'Dermatologist',
  INVENTORY_STAFF: 'Inventory Staff'
};

const authenticatedRole = 'Administrator';
let accessToken = null;
let refreshToken = null;
let currentUserEmail = null;
// The database id of the signed-in clinician, used to warn about a follow-up that would collide
// with their own schedule. It comes from the staff list the role already loads, not a second request.
let currentUserId = null;
let sessionTimer;
let editingPatientId = null;
let patientDetailPatientId = null;
let patientPage = 1;
let patientView = 'active';
let archivedPatientsLoaded = false;
const pageSize = 3;
const patients = [];
const archivedPatients = [];
const appointments = [];
const consultations = [];
const services = [];
const dockets = [];
const inventory = [];
const movements = [];
const users = [];
const therapists = [];
const auditEvents = [];
const rolePermissions = {
  Administrator: ['System overview', 'User management', 'Role management', 'Audit trail', 'Sales reports', 'Reports', 'Configuration', 'Full authorized administration'],
  Receptionist: ['Patient registration and search', 'Appointments', 'Treatment dockets', 'Scheduling-related workflows'],
  Dermatologist: ['Consultations', 'Diagnoses', 'Clinical information', 'Treatment recommendations', 'Authorized patient and treatment information'],
  'Inventory Staff': ['Products', 'Suppliers', 'Stock', 'Inventory movements', 'Low-stock monitoring', 'Expiry monitoring', 'Stock In and Stock Out recording']
};

let editingServiceId = null;
let editingUserId = null;
let editingAppointmentId = null;
let followUpConsultationId = null;
const suppliers = [];
const sessionDurationSeconds = (role) => role === 'Administrator' ? 5 * 60 : 15 * 60;
const roleNames = {
  Administrator: ['Administrator', 'AD'],
  Receptionist: ['Receptionist', 'RE'],
  Dermatologist: ['Dermatologist', 'DE'],
  'Inventory Staff': ['Inventory Staff', 'IS']
};

// Role names reach the browser in whichever casing a given database happens to use
// ("Inventory Staff" from a legacy row, "INVENTORY_STAFF" from the seed migration).
// Collapse whitespace to underscores and upper-case, exactly as the backend's
// JwtAuthenticationFilter does, so every caller resolves the same role the same way.
function roleLabelFromName(name) {
  return roleLabels[String(name || '').toUpperCase().replace(/\s+/g, '_')] || null;
}

function roleFromAccessToken(token) {
  try {
    const payload = JSON.parse(atob(token.split('.')[1].replace(/-/g, '+').replace(/_/g, '/')));
    return roleLabelFromName(payload.role);
  } catch {
    return null;
  }
}

function updateRole(role) {
  const [name, initials] = roleNames[role];
  document.getElementById('profileName').textContent = name;
  document.getElementById('profileInitials').textContent = initials;
  // The top bar avatar is the same person as the sidebar profile, so it carries the same initials.
  // It used to be a fixed "SO" baked into the markup, which disagreed with every other role.
  document.getElementById('topAvatar').textContent = initials;
  document.getElementById('profileRole').textContent = role;
  applyRoleAccess(role);
}

// Role -> the views it may open. One source of truth, read by the sidebar, by the workspace
// switch, and after every role change, so what is on screen can never disagree with the role
// that is signed in. The previous substring test let one name satisfy another ("Dockets" is
// inside "Treatment dockets"), so this compares complete names.
function allowedViews(role) {
  return {
    Administrator: ['Overview', 'Patients', 'Appointments', 'Consultations', 'Treatment dockets', 'Inventory', 'Sales', 'Reports', 'Services', 'Team & access', 'Audit trail'],
    Receptionist: ['Overview', 'Patients', 'Appointments', 'Treatment dockets'],
    Dermatologist: ['Overview', 'Patients', 'Appointments', 'Consultations', 'Treatment dockets'],
    'Inventory Staff': ['Overview', 'Inventory', 'Reports']
  }[role] || ['Overview'];
}

function applyRoleAccess(role) {
  const access = allowedViews(role);
  document.querySelectorAll('.nav-item').forEach((item) => { item.hidden = !access.includes(item.dataset.view); });
  // A group heading with no visible items under it is noise, so hide those too.
  document.querySelectorAll('.nav-label').forEach((label) => {
    let sibling = label.nextElementSibling;
    let groupHasItems = false;
    while (sibling && !sibling.classList.contains('nav-label')) {
      if (sibling.classList.contains('nav-item') && !sibling.hidden) { groupHasItems = true; break; }
      sibling = sibling.nextElementSibling;
    }
    label.hidden = !groupHasItems;
  });
  // Re-show whatever is on screen through the same path a click uses. If the previous view is
  // out of reach for this role, this falls back to the role's first view, so signing in as a
  // different account can never leave an unauthorised workspace visible.
  const current = document.querySelector('.nav-item.active:not([hidden])')?.dataset.view;
  showView(access.includes(current) ? current : access[0]);
}

// The loading bar is shown only while a request is actually in flight.
function setWorkspaceStatus(visible) {
  document.getElementById('workspaceStatus')?.classList.toggle('visible', visible);
}

function showToast(title, message) {
  toast.querySelector('b').textContent = title;
  toast.querySelector('small').textContent = message;
  toast.classList.add('show');
  window.setTimeout(() => toast.classList.remove('show'), 3200);
}

// Promise-based confirmation so destructive actions use the application's own modal styling
// instead of the browser's default confirm() popup. Resolves true when confirmed, false when
// cancelled by the Cancel button, the close cross, or a click on the backdrop.
function confirmAction({ title, message, confirmLabel }) {
  return new Promise((resolve) => {
    const confirmBackdrop = document.getElementById('confirmModal');
    const confirmAccept = document.getElementById('confirmAccept');
    const confirmCancel = document.getElementById('confirmCancel');
    const confirmClose = document.getElementById('confirmClose');
    document.getElementById('confirmTitle').textContent = title;
    document.getElementById('confirmMessage').textContent = message;
    confirmAccept.textContent = confirmLabel;
    const finish = (result) => {
      closeModal(confirmBackdrop);
      confirmAccept.removeEventListener('click', onAccept);
      confirmCancel.removeEventListener('click', onCancel);
      confirmClose.removeEventListener('click', onCancel);
      confirmBackdrop.removeEventListener('click', onBackdrop);
      resolve(result);
    };
    const onAccept = () => finish(true);
    const onCancel = () => finish(false);
    const onBackdrop = (event) => { if (event.target === confirmBackdrop) finish(false); };
    confirmAccept.addEventListener('click', onAccept);
    confirmCancel.addEventListener('click', onCancel);
    confirmClose.addEventListener('click', onCancel);
    confirmBackdrop.addEventListener('click', onBackdrop);
    openModal(confirmBackdrop);
  });
}

// ---------------------------------------------------------------- dialog behaviour
// One place that knows how a dialog opens and closes, so every modal behaves the same way:
// Escape closes it, clicking the backdrop closes it, focus moves into it when it opens and
// returns to whatever opened it when it closes.
let lastFocusedElement = null;

function focusModal(backdrop) {
  const target = backdrop.querySelector('input:not([type="hidden"]), select, textarea')
    || backdrop.querySelector('.modal-close')
    || backdrop.querySelector('button');
  if (target) target.focus();
}

// Everything the user can tab to inside a dialog. Queried live rather than cached, because a dialog's
// contents are replaced wholesale by the render functions while it is open.
function focusableWithin(backdrop) {
  return [...backdrop.querySelectorAll('button, [href], input:not([type="hidden"]), select, textarea, [tabindex]:not([tabindex="-1"])')]
    .filter((element) => !element.disabled && element.offsetParent !== null);
}

// The dialogs declare aria-modal="true", which promises that the rest of the page is inert. Without
// this, Tab walks straight out of the dialog into the page behind it. Focus is wrapped at both ends
// so it can never escape while a dialog is open.
function trapFocus(backdrop, event) {
  if (event.key !== 'Tab') return;
  const items = focusableWithin(backdrop);
  if (!items.length) return;
  const first = items[0];
  const last = items[items.length - 1];
  const active = document.activeElement;
  // Focus can sit on the backdrop itself (or on nothing) right after opening; pull it back inside.
  if (!backdrop.contains(active)) { event.preventDefault(); first.focus(); return; }
  if (event.shiftKey && active === first) { event.preventDefault(); last.focus(); }
  else if (!event.shiftKey && active === last) { event.preventDefault(); first.focus(); }
}

function openModal(target) {
  const backdrop = typeof target === 'string' ? document.getElementById(target) : target;
  if (!backdrop) return;
  lastFocusedElement = document.activeElement;
  backdrop.classList.add('open');
  // Lock the page behind the dialog. Without this, scrolling inside a tall dialog on a phone moves
  // the page underneath it instead.
  document.body.classList.add('modal-open');
  focusModal(backdrop);
}

function closeModal(target) {
  const backdrop = typeof target === 'string' ? document.getElementById(target) : target;
  if (!backdrop) return;
  backdrop.classList.remove('open');
  // Several dialogs can be open at once (a confirm raised from a form), so the lock is only released
  // once the last one is gone.
  if (!document.querySelector('.modal-backdrop.open')) document.body.classList.remove('modal-open');
  if (lastFocusedElement && document.contains(lastFocusedElement)) lastFocusedElement.focus();
  lastFocusedElement = null;
}

document.addEventListener('keydown', (event) => {
  const open = [...document.querySelectorAll('.modal-backdrop.open')].pop();
  if (open) trapFocus(open, event);
  if (event.key !== 'Escape') return;
  if (!open) return;
  event.preventDefault();
  // The confirm dialog owns a promise, so it must be dismissed through its own Cancel button
  // rather than by hiding the element, or the caller would wait forever.
  if (open.id === 'confirmModal') { document.getElementById('confirmCancel').click(); return; }
  closeModal(open);
});

document.querySelectorAll('.modal-backdrop').forEach((backdrop) => {
  // confirmAction installs its own dismissal for its dialog.
  if (backdrop.id === 'confirmModal') return;
  // mousedown on the backdrop itself, not click: a drag that begins inside the dialog and ends
  // over the backdrop would otherwise register as a click on the backdrop and close it.
  backdrop.addEventListener('mousedown', (event) => { if (event.target === backdrop) closeModal(backdrop); });
});

function persistSession(sessionRole, email, expiresInSeconds) {
  const expiresAt = Date.now() + expiresInSeconds * 1000;
  window.sessionStorage.setItem(sessionKey, JSON.stringify({ role: sessionRole, email, accessToken, refreshToken, expiresAt }));
  window.clearTimeout(sessionTimer);
  sessionTimer = window.setTimeout(renewOrEndSession, Math.max(1000, expiresAt - Date.now()));
}

// The access token is deliberately short-lived, so the stored refresh token is exchanged for a
// fresh one instead of dropping the user at the login screen the moment the access token lapses.
async function renewSession() {
  if (!refreshToken) return false;
  try {
    const response = await fetch(`${apiBaseUrl}/api/auth/refresh`, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ refreshToken }) });
    if (!response.ok) return false;
    const tokenResponse = await response.json();
    if (!tokenResponse.accessToken) return false;
    accessToken = tokenResponse.accessToken;
    refreshToken = tokenResponse.refreshToken || refreshToken;
    const role = roleFromAccessToken(accessToken) || authenticatedRole;
    persistSession(role, currentUserEmail, tokenResponse.expiresInSeconds || sessionDurationSeconds(role));
    return true;
  } catch {
    return false;
  }
}

async function renewOrEndSession() {
  if (await renewSession()) return;
  endSession('Your session expired. Please sign in again.');
}

function endSession(message = 'Your clinic session has ended.') {
  window.clearTimeout(sessionTimer);
  window.sessionStorage.removeItem(sessionKey);
  accessToken = null;
  refreshToken = null;
  appShell.hidden = true;
  loginScreen.hidden = false;
  showToast('Signed out', message);
}

async function restoreSession() {
  // One-time cleanup of the shared-storage session this used to use. Cheap and self-healing: a
  // missing key is a no-op, and once cleared it stays cleared.
  window.localStorage.removeItem(legacySessionKey);
  const savedSession = window.sessionStorage.getItem(sessionKey);
  if (!savedSession) return;
  let session;
  try {
    session = JSON.parse(savedSession);
  } catch {
    window.sessionStorage.removeItem(sessionKey);
    return;
  }
  if (!session.role || !roleNames[session.role] || !session.accessToken) {
    window.sessionStorage.removeItem(sessionKey);
    return;
  }
  accessToken = session.accessToken;
  refreshToken = session.refreshToken;
  currentUserEmail = session.email || null;
  if (session.expiresAt <= Date.now()) {
    // Already lapsed before the page loaded, so a plain refresh would sign the user out. Try the
    // refresh token first and only fall back to the login screen when that exchange fails.
    if (!await renewSession()) {
      window.sessionStorage.removeItem(sessionKey);
      accessToken = null;
      refreshToken = null;
      return;
    }
  } else {
    window.clearTimeout(sessionTimer);
    sessionTimer = window.setTimeout(renewOrEndSession, Math.max(1000, session.expiresAt - Date.now()));
  }
  updateRole(session.role);
  loginScreen.hidden = true;
  // Same reason as the sign-in path: the workspace is built while hidden so the placeholder figures
  // in index.html are never on screen, then revealed once it holds real records.
  await loadPatients();
  await loadCountries();
  await loadClinicData(session.role);
  appShell.hidden = false;
}

function mapPatient(record) {
  const name = record.fullName || '';
  // phoneDisplay is the number as the server says it should read, so the interface never formats a
  // number itself; phoneNational and phoneRegion are what editing a record needs to put the value
  // back in the form exactly as it was entered.
  // id is the database key every request addresses the patient by; patientNumber is the identifier
  // a person reads and quotes. They are different values, so both are kept: the directory shows the
  // number and the buttons send the id.
  return { id: String(record.id), patientNumber: record.patientNumber || '', name, email: record.email || '', phone: record.phone || '', phoneDisplay: record.phoneDisplay || '', phoneNational: record.phoneNational || '', phoneRegion: record.phoneRegion || '', dob: record.dateOfBirth || '', skinType: record.skinType || '', allergies: record.allergies || '', status: String(record.status || 'ACTIVE').toLowerCase() };
}

async function apiRequest(path, options = {}) {
  const response = await fetch(`${apiBaseUrl}${path}`, { ...options, headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${accessToken}`, ...(options.headers || {}) } });
  if (!response.ok) {
    let message = `Request failed (${response.status})`;
    try {
      const payload = await response.json();
      if (payload.message) message = payload.message;
    } catch {
      // Keep the status message when the server does not return JSON.
    }
    const error = new Error(message);
    error.status = response.status;
    throw error;
  }
  // Void controller methods (archive/restore and the clinic command endpoints) answer with
  // 200 and an empty body, so read the text first instead of assuming JSON is always there.
  const body = await response.text();
  return body ? JSON.parse(body) : null;
}

function saveErrorMessage(error, fallback) {
  if (error?.status === 401) return 'Your session expired. Please sign in again.';
  // Prefer the server's own wording. Authorization failures name the rule that refused the action,
  // which is far more useful than a generic role error.
  if (error?.status === 403) return error.message || 'Your current role is not allowed to perform this action.';
  if (error?.status === 409) return error.message || 'A record with these details already exists.';
  if (error?.status === 400) return error.message || 'Please check the entered values.';
  return fallback;
}

function datePart(value) {
  return value ? String(value).slice(0, 10) : '';
}

// Builds the same YYYY-MM-DD shape the server sends for date fields, from a local Date. Comparing
// date strings avoids `new Date('2026-10-13')`, which is parsed as UTC midnight and therefore moves
// the boundary onto the previous or next day for anyone not on UTC.
function localDateKey(date) {
  return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`;
}

function timePart(value) {
  return value ? String(value).slice(11, 16) : '';
}

function formatCurrentDate(date = new Date()) {
  return new Intl.DateTimeFormat(undefined, { weekday: 'long', day: 'numeric', month: 'long', year: 'numeric' }).format(date);
}

function updateCurrentDate() {
  const dateText = formatCurrentDate();
  document.querySelectorAll('[data-current-date]').forEach((element) => { element.textContent = dateText; });
  document.getElementById('pageEyebrow').textContent = dateText;
}

// The Overview panels are drawn from the same arrays the workspaces use. There is no revenue
// panel: money is processed by the clinic's external POS, so this application never stores or
// derives a financial figure.

function updateDashboard() {
  // Every date the server sends is the clinic's own wall-clock date, so "today" has to be the local
  // calendar day too. `toISOString().slice(0,10)` would be the UTC day, which is still yesterday for
  // the first eight hours of a UTC+8 morning -- the dashboard would open on the wrong day.
  const today = localDateKey(new Date());
  const todayAppointments = appointments.filter((item) => item.date === today);
  const lowStock = inventory.filter((item) => item.stockStatus === 'LOW_STOCK').length;
  const expiryRisk = inventory.filter((item) => item.stockStatus === 'NEARLY_EXPIRED' || item.stockStatus === 'EXPIRED').length;
  const inventoryMetrics = document.querySelectorAll('#inventoryWorkspace .inventory-summary .metric-card b');
  if (inventoryMetrics.length >= 4) {
    inventoryMetrics[0].textContent = inventory.length;
    inventoryMetrics[1].textContent = lowStock;
    inventoryMetrics[2].textContent = expiryRisk;
    inventoryMetrics[3].textContent = movements.length;
  }
  const schedule = document.getElementById('scheduleList');
  if (schedule) schedule.innerHTML = todayAppointments.length ? todayAppointments.map((item) => `<div class="schedule-row"><time>${escapeHtml(item.time)}</time><div class="timeline-dot upcoming"></div><div class="patient-avatar blue-bg">${escapeHtml(item.patient.slice(0, 2).toUpperCase())}</div><div class="appointment-info"><b>${escapeHtml(item.patient)}</b><span>${escapeHtml(item.type)} · ${escapeHtml(item.staff)}</span></div><span class="status ${escapeHtml(item.status)}">${escapeHtml(item.status)}</span></div>`).join('') : '<div class="patient-empty">No appointments scheduled for today.</div>';
  document.getElementById('dashboardAppointments').textContent = todayAppointments.length;
  // Only the docket-raising roles load the docket list. Any other role sees a dash rather than a
  // confident zero, which would claim the clinic has no treatment dockets.
  document.getElementById('dashboardDockets').textContent =
    ['Administrator', 'Receptionist', 'Dermatologist'].includes(document.getElementById('profileRole').textContent)
      ? dockets.length
      : '—';
  document.getElementById('dashboardPatients').textContent = patients.length;
  document.getElementById('dashboardLowStock').textContent = lowStock;
  const patientNavCount = document.querySelector('[data-view="Patients"] em');
  if (patientNavCount) patientNavCount.textContent = patients.length;
  const userCount = document.getElementById('userCount');
  if (userCount) userCount.textContent = `${users.length} users`;
  const scheduleDate = document.querySelector('.schedule-panel .panel-header p');
  if (scheduleDate) scheduleDate.textContent = formatCurrentDate();
  // "Items needing your attention" shipped as three fictional products with fixed stock counts, so
  // the panel read as live data while never changing. It now lists the real products the server has
  // marked as low stock, nearly expired or expired.
  const watchList = document.querySelector('.inventory-panel .inventory-list');
  if (watchList) {
    const needsAttention = inventory
      .filter((item) => item.stockStatus && item.stockStatus !== 'IN_STOCK')
      .sort((a, b) => (stockAlertRank[a.stockStatus] - stockAlertRank[b.stockStatus]) || (a.stock - a.reorder) - (b.stock - b.reorder))
      .slice(0, 4);
    watchList.innerHTML = needsAttention.length
      ? needsAttention.map((item) => {
        const out = item.stock <= 0;
        const label = out ? 'Out of stock' : stockStatusOf(item).label;
        return `<div class="inventory-item"><div class="product-symbol ${out ? '' : 'pink'}">◉</div><div class="product-info"><b>${escapeHtml(item.name)}</b><span>Product code · ${escapeHtml(item.sku)}</span></div><div class="stock-level"><b>${escapeHtml(item.stock)} ${escapeHtml(item.unit)}</b><span class="${out ? 'critical' : 'low'}">${label}</span></div></div>`;
      }).join('')
      : '<div class="patient-empty">Every product is above its reorder threshold and nothing is expiring soon.</div>';
  }
  updateNotificationDot();
}

// The bell only shows a dot when there is genuinely something to look at.
function updateNotificationDot() {
  const dot = document.getElementById('notificationDot');
  if (!dot) return;
  const alerts = inventory.filter((item) => item.stockStatus && item.stockStatus !== 'IN_STOCK').length;
  dot.hidden = alerts === 0;
}

function mapClinicData(records, role) {
  appointments.splice(0, appointments.length, ...records.appointments.map((item) => ({ id: item.appointmentNumber, dbId: String(item.id), patient: item.patient, patientId: String(item.patientId), patientNumber: item.patientNumber || '', phone: item.phone || '', phoneDisplay: item.phoneDisplay || item.phone || '', notes: item.notes || '', staffId: item.staffId != null ? String(item.staffId) : '', therapistId: item.therapistId != null ? String(item.therapistId) : '', therapist: item.therapist || '', date: datePart(item.startsAt), time: timePart(item.startsAt), staff: item.staff, type: 'Clinic appointment', status: String(item.status).toLowerCase() })));
  consultations.splice(0, consultations.length, ...records.consultations.map((item) => ({ id: item.consultationNumber, dbId: String(item.id), patientId: String(item.patientId || ''), patient: item.patient, diagnosis: item.diagnosis, recommendation: item.recommendation, notes: item.notes, followup: item.followup, followupDate: item.followupDate || '', followupTime: item.followupTime || '', followupAppointment: item.followupAppointment || '', author: item.author, created: item.createdAt })));
  dockets.splice(0, dockets.length, ...records.dockets.map((item) => {
    // created_at is a UTC instant. The QR is read at the clinic, so its date and time are resolved
    // in the browser's own time zone rather than leaving a late-evening treatment dated to tomorrow.
    const created = item.createdAt ? new Date(item.createdAt) : null;
    const createdTime = created ? created.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit', hour12: false }) : '';
    const items = (Array.isArray(item.items) ? item.items : []).map((line) => ({
      id: String(line.id),
      type: String(line.type || '').toUpperCase(),
      serviceId: line.serviceId == null ? '' : String(line.serviceId),
      serviceCode: line.serviceCode || '',
      productId: line.productId == null ? '' : String(line.productId),
      productSku: line.productSku || '',
      productUnit: line.productUnit || '',
      name: line.name || 'Item removed',
      quantity: Number(line.quantity || 1),
      unitPrice: line.unitPrice == null ? null : Number(line.unitPrice),
      lineTotal: line.lineTotal == null ? null : Number(line.lineTotal)
    }));
    return { id: item.docketNumber, dbId: String(item.id), patient: item.patient, patientId: String(item.patientId), patientReference: item.patientReference || '', appointment: item.appointment || 'Unassigned', appointmentId: item.appointmentId ? String(item.appointmentId) : '', itemSummary: item.itemSummary || items.map((line) => line.name).join(', '), items, total: item.total == null ? null : Number(item.total), dermatologist: item.dermatologist, therapist: item.therapist, status: String(item.status).toLowerCase(), created: created ? localDateKey(created) : '', createdAt: item.createdAt || '', createdTime };
  }));
  services.splice(0, services.length, ...records.services.map((item) => ({ id: String(item.id), dbId: String(item.id), code: item.code, name: item.name, category: item.category, price: Number(item.price), duration: Number(item.duration), description: item.description, products: (Array.isArray(item.products) ? item.products : []).map((product) => ({ productId: String(product.productId), product: product.product, quantity: Number(product.quantity), unit: product.unit || '' })), status: String(item.status).toLowerCase() })));
  inventory.splice(0, inventory.length, ...records.inventory.map((item) => ({ id: String(item.id), dbId: String(item.id), name: item.name, sku: item.sku, supplier: item.supplier || 'Unassigned', supplierId: item.supplierId ? String(item.supplierId) : '', batch: item.batch || 'No batch', expiry: datePart(item.expiry), stock: Number(item.stock), reorder: Number(item.reorder), unit: item.unit, usageType: item.usageType === 'RETAIL' ? 'RETAIL' : 'CLINIC', stockStatus: item.stockStatus || '' })));
  // A movement reads product, movement type and product supplier first, the three facts the form is
  // built around. The supplier is the one the server resolved from the product, not typed text. A
  // legacy ADJUSTMENT row (no longer writable) is shown by the direction it moved the stock.
  movements.splice(0, movements.length, ...records.movements.map((item) => ({ product: item.product, usageType: item.usageType === 'RETAIL' ? 'RETAIL' : 'CLINIC', type: item.type === 'STOCK_IN' || (item.type === 'ADJUSTMENT' && Number(item.quantity) > 0) ? 'Stock In' : 'Stock Out', supplier: item.supplier || 'Unassigned', quantity: Number(item.quantity), batch: item.batch || 'No batch', user: item.user, time: item.createdAt })));
  if (['Administrator', 'Receptionist', 'Dermatologist'].includes(role)) users.splice(0, users.length, ...records.users.map((item) => ({ id: String(item.id), name: item.fullName, email: item.email, idNumber: item.idNumber || '', role: roleLabelFromName(item.role) || item.role, active: item.status === 'ACTIVE' })));
  therapists.splice(0, therapists.length, ...(records.therapists || []).map((item) => ({ id: String(item.id), name: item.fullName, email: item.email || '', phone: item.phone || '', age: item.age, idNumber: item.idNumber || '', status: String(item.status || 'ACTIVE').toLowerCase() })));
  const currentUser = records.users.find((item) => item.email === currentUserEmail);
  currentUserId = currentUser ? String(currentUser.id) : null;
  if (currentUser) {
    roleNames[role] = [currentUser.fullName, currentUser.fullName.split(/\s+/).map((part) => part[0]).join('').slice(0, 2).toUpperCase()];
    updateRole(role);
  }
}

async function loadClinicData(role) {
  const requests = {
    appointments: ['Administrator', 'Receptionist', 'Dermatologist'].includes(role) ? apiRequest('/api/clinic/appointments') : Promise.resolve([]),
    consultations: ['Administrator', 'Dermatologist'].includes(role) ? apiRequest('/api/clinic/consultations') : Promise.resolve([]),
    dockets: ['Administrator', 'Receptionist', 'Dermatologist'].includes(role) ? apiRequest('/api/clinic/dockets') : Promise.resolve([]),
    // The service catalogue is Administrator-only now, but the three docket-raising roles still read
    // it: the docket form's service dropdown is built from this list, so dropping them here would
    // leave a working docket form with an empty service picker.
    services: ['Administrator', 'Receptionist', 'Dermatologist'].includes(role) ? apiRequest('/api/clinic/services') : Promise.resolve([]),
    // Receptionist is included because the docket form's costing table shows each required product's
    // available quantity, and the retail picker is built from this same list. The backend already
    // permits Receptionist to read inventory; without this the columns would all read "Not found".
    inventory: ['Administrator', 'Receptionist', 'Inventory Staff'].includes(role) ? apiRequest('/api/clinic/inventory') : Promise.resolve([]),
    movements: ['Administrator', 'Inventory Staff'].includes(role) ? apiRequest('/api/clinic/movements') : Promise.resolve([]),
    users: role === 'Administrator' ? apiRequest('/api/users') : ['Receptionist', 'Dermatologist'].includes(role) ? apiRequest('/api/users/staff') : Promise.resolve([]),
    therapists: ['Administrator', 'Receptionist', 'Dermatologist'].includes(role) ? apiRequest('/api/therapists') : Promise.resolve([])
  };
  setWorkspaceStatus(true);
  const entries = await Promise.all(Object.entries(requests).map(async ([name, request]) => [name, await request.catch(() => [])]));
  mapClinicData(Object.fromEntries(entries), role);
  updateCurrentDate();
  renderAppointmentAlert();
  updateDashboard();
  if (role === 'Administrator') {
    await loadAuditEvents().catch(() => auditEvents.splice(0, auditEvents.length));
  }
  if (['Administrator', 'Inventory Staff'].includes(role)) {
    await loadSuppliers().catch(() => suppliers.splice(0, suppliers.length));
  }
  renderRecentActivity(role);
  setWorkspaceStatus(false);
  // The view was chosen during sign-in, before this data arrived, so the workspace the role ended up
  // on is drawn again now that the arrays behind it are populated. Without this, signing in as a
  // role while another role's view is still active shows an empty table until the user clicks away.
  const visibleView = document.querySelector('.nav-item.active:not([hidden])')?.dataset.view;
  if (visibleView) showView(visibleView);
}

const escapeHtml = (value) => String(value ?? '').replace(/[&<>"']/g, (character) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[character]));

// Patient phone numbers are stored in canonical ITU-T E.164 form, for any country: "+" followed by
// the country code and the national number, and nothing else. One real number therefore has exactly
// one representation.
//
// The rule is deliberately NOT repeated here. A hand-written Philippine-only copy of it used to live
// in this file, and that copy is precisely what made a Chinese number impossible to record. Deciding
// what is a real number in 200-plus countries is the server's job now (PhoneNumbers.java, on top of
// libphonenumber) and it is also the only side that can be trusted, since anything can post to the
// API directly. What travels in each direction is:
//
//   to the server    phone    the raw value as typed, unformatted
//                    country  the region chosen in the list beside the field, used only when the
//                             value carries no country code of its own
//   from the server  phone        canonical E.164
//                    phoneDisplay international form, for reading: "+86 138 0013 8000"
//                    phoneNational  the country's own form, for editing: "138 0013 8000"
//                    phoneRegion    the country the number belongs to, used to select it in the list
let countries = [];

// Fills the country list beside the phone field. Loaded rather than written into the page so the set
// of countries comes from the same library that parses the numbers; a hand-written list would drift,
// and the drift would show up as a country that can be chosen but whose numbers are then rejected.
async function loadCountries() {
  const select = document.getElementById('patientCountryInput');
  if (!select) return;
  try {
    countries = await apiRequest('/api/countries');
  } catch {
    // A failed load must not block patient registration. The field still accepts a number that
    // carries its own country code, which is the unambiguous way to enter a foreign one, so the
    // fallback below is the country this clinic is in rather than an unusable empty list.
    countries = [];
  }
  select.innerHTML = countries.length
    ? countries.map((country) => `<option value="${escapeHtml(country.region)}">${escapeHtml(country.name)} (${escapeHtml(country.dialCode)})</option>`).join('')
    : '<option value="PH">Philippines (+63)</option>';
  select.value = 'PH';
}

function relativeTime(value) {
  const then = new Date(value).getTime();
  if (!then) return '';
  const minutes = Math.round((Date.now() - then) / 60000);
  if (minutes < 1) return 'now';
  if (minutes < 60) return `${minutes}m`;
  const hours = Math.round(minutes / 60);
  if (hours < 24) return `${hours}h`;
  return `${Math.round(hours / 24)}d`;
}

const activityActionLabel = (action) => String(action).toLowerCase().replace(/_/g, ' ').replace(/^./, (letter) => letter.toUpperCase());

const activityModuleLook = (module) => ({
  Inventory: ['peach-bg', '◉'],
  Appointments: ['blue-bg', '◷'],
  Treatment: ['green-bg', '✓'],
  Services: ['lavender', '✦'],
  Team: ['peach-bg', '♧'],
  Patients: ['blue-bg', '♙']
}[module] || ['blue-bg', '•']);

// The audit trail is the single source of truth for what happened in the clinic. The dashboard
// panel and the Audit workspace are two views of the same records, so both read this one list
// instead of each fetching or keeping a parallel in-memory copy that can drift.
function formatTimestamp(value) {
  if (value == null || value === '') return '—';
  const date = typeof value === 'number' ? new Date(value) : new Date(String(value).replace(' ', 'T'));
  return Number.isNaN(date.getTime()) ? String(value) : date.toLocaleString();
}

async function loadAuditEvents() {
  const records = await apiRequest('/api/audit-logs');
  auditEvents.splice(0, auditEvents.length, ...records.map((record) => ({
    user: record.user || 'System',
    module: record.module || '—',
    action: String(record.action || ''),
    record: record.recordIdentifier || '—',
    reference: record.reference || '—',
    time: formatTimestamp(record.createdAt),
    createdAt: record.createdAt
  })));
}

function renderRecentActivity(role) {
  const list = document.getElementById('activityList');
  if (!list) return;
  if (role !== 'Administrator') {
    list.innerHTML = '<div class="patient-empty">Recent activity is available to Administrators.</div>';
    return;
  }
  list.innerHTML = auditEvents.length
    ? auditEvents.slice(0, 3).map((record) => {
        const [tone, icon] = activityModuleLook(record.module);
        const detail = [record.user, record.reference].filter(Boolean).map(escapeHtml).join(' · ');
        return `<div class="activity-item"><div class="activity-icon ${tone}">${icon}</div><div><b>${escapeHtml(activityActionLabel(record.action))}</b><span>${detail}</span></div><time>${relativeTime(record.createdAt)}</time></div>`;
      }).join('')
    : '<div class="patient-empty">No recent activity.</div>';
}

async function loadPatients() {
  // The patient directory loads outside loadClinicData, so it did not show the in-flight indicator
  // and the table simply sat empty until the response arrived.
  setWorkspaceStatus(true);
  try {
    const records = await apiRequest('/api/patients');
    patients.splice(0, patients.length, ...records.map(mapPatient));
    patientPage = 1;
    renderPatients();
  } catch (error) {
    showToast('Patient data unavailable', 'Check that the backend and MySQL database are running.');
  } finally {
    setWorkspaceStatus(false);
  }
}

async function loadArchivedPatients() {
  setWorkspaceStatus(true);
  try {
    const records = await apiRequest('/api/patients/archived');
    archivedPatients.splice(0, archivedPatients.length, ...records.map(mapPatient));
    archivedPatientsLoaded = true;
    return true;
  } catch (error) {
    showToast('Archived patient data unavailable', saveErrorMessage(error, 'Check that the backend and MySQL database are running.'));
    return false;
  } finally {
    setWorkspaceStatus(false);
  }
}

function setPatientView(view) {
  patientView = view;
  const archived = view === 'archived';
  document.getElementById('activePatientsTab').classList.toggle('active', !archived);
  document.getElementById('activePatientsTab').setAttribute('aria-selected', String(!archived));
  document.getElementById('activePatientsTab').tabIndex = archived ? -1 : 0;
  document.getElementById('archivedPatientsTab').classList.toggle('active', archived);
  document.getElementById('archivedPatientsTab').setAttribute('aria-selected', String(archived));
  document.getElementById('archivedPatientsTab').tabIndex = archived ? 0 : -1;
  document.getElementById('patientTablePanel').setAttribute('aria-labelledby', archived ? 'archivedPatientsTab' : 'activePatientsTab');
  document.getElementById('patientListTitle').textContent = archived ? 'Archived patients' : 'Patient directory';
  document.getElementById('patientRegisterButton').hidden = archived;
}

function renderPatients() {
  const visiblePatients = patientView === 'archived' ? archivedPatients : patients;
  const query = document.getElementById('patientSearch').value.trim().toLowerCase();
  const filtered = visiblePatients.filter((patient) => !query || `${patient.name} ${patient.patientNumber}`.toLowerCase().includes(query));
  const pageCount = Math.max(1, Math.ceil(filtered.length / pageSize));
  patientPage = Math.min(patientPage, pageCount);
  const pageRows = filtered.slice((patientPage - 1) * pageSize, patientPage * pageSize);
  document.getElementById('patientCount').textContent = `${filtered.length} patient record${filtered.length === 1 ? '' : 's'}`;
  // The directory shows only the two fields the clinic asked for. Contact details, visit metadata
  // and status stay on the patient's profile and are not repeated here. The number is the patient
  // number printed on the record, not the database id the buttons use.
  document.getElementById('patientTable').innerHTML = pageRows.length ? pageRows.map((patient) => {
    const statusAction = document.getElementById('profileRole').textContent === 'Administrator'
      ? `<button data-action="archive" data-id="${escapeHtml(patient.id)}">${patientView === 'active' ? 'Archive' : 'Restore'}</button>`
      : '';
    return `<div class="patient-row patient-row--no-status"><div class="patient-person"><div><b>${escapeHtml(patient.name)}</b></div></div><div class="patient-contact">${escapeHtml(patient.patientNumber)}</div><div class="patient-actions"><button data-action="view" data-id="${escapeHtml(patient.id)}">View</button><button data-action="edit" data-id="${escapeHtml(patient.id)}">Edit</button>${statusAction}</div></div>`;
  }).join('') : `<div class="patient-empty">${patientView === 'archived' ? 'No archived patient records match this search.' : 'No patients match this search.'}</div>`;
  document.getElementById('patientPagination').innerHTML = pageCount > 1 ? `<button ${patientPage === 1 ? 'disabled' : ''} data-page="${escapeHtml(patientPage - 1)}">← Previous</button><span>Page ${patientPage} of ${pageCount}</span><button ${patientPage === pageCount ? 'disabled' : ''} data-page="${escapeHtml(patientPage + 1)}">Next →</button>` : '';
}

function openPatientModal(patient) {
  editingPatientId = patient?.id || null;
  document.getElementById('patientModalTitle').textContent = patient ? 'Update patient' : 'Add a new patient';
  document.getElementById('patientSubmitButton').innerHTML = patient ? 'Save changes <span>→</span>' : 'Create patient <span>→</span>';
  document.getElementById('patientNameInput').value = patient?.name || '';
  document.getElementById('patientEmailInput').value = patient?.email || '';
  // The country is restored alongside the number, because the national form alone does not say which
  // country it belongs to -- "138 0013 8000" is only a Chinese number because China is selected. With
  // both back in place, re-submitting reproduces the stored number exactly.
  document.getElementById('patientPhoneInput').value = patient?.phoneNational || '';
  document.getElementById('patientCountryInput').value = patient?.phoneRegion || 'PH';
  document.getElementById('patientDobInput').value = patient?.dob || '';
  document.getElementById('patientSkinTypeInput').value = patient?.skinType || '';
  document.getElementById('patientAllergiesInput').value = patient?.allergies || '';
  openModal("modal");
  focusModal(modal);
}

// The profile reads its wording from the form's own <select> rather than a second list of labels
// here. The dropdown is where a clinician already chose "Oily", so taking the label from that option
// means the two can never disagree -- and a skin type that somehow has no option still renders as
// its stored value instead of vanishing.
function skinTypeLabel(value) {
  if (!value) return 'Not assessed';
  const option = document.querySelector(`#patientSkinTypeInput option[value="${CSS.escape(value)}"]`);
  return option ? option.textContent : value;
}

// A value that was never filled in is shown in its own words and in a softer ink, so an unassessed
// patient reads as "nothing recorded yet" rather than as a fact that happens to be short. Without the
// second part the fallback text carries the same weight and colour as a real allergy, and the two are
// indistinguishable at a glance -- which is the wrong way round for a clinical record.
function setDetailValue(id, text, empty) {
  const element = document.getElementById(id);
  element.textContent = text;
  element.classList.toggle('detail-empty', Boolean(empty));
}

// The visit history in the profile is assembled from the records the signed-in role has already
// loaded, not from a second request. That is deliberate: appointments, dockets and consultations are
// each fetched only for the roles allowed to read them, so an array a role cannot see is empty and
// the profile cannot reveal more than the role's own workspace. It also means the history is already
// on the page when View is clicked, so the modal opens complete rather than filling in a moment later.
const historyAccess = {
  appointments: ['Administrator', 'Receptionist', 'Dermatologist'],
  treatments: ['Administrator', 'Receptionist', 'Dermatologist'],
  consultations: ['Administrator', 'Dermatologist']
};

function historyCount(count, singular, plural) {
  return `${count} ${count === 1 ? singular : plural}`;
}

function historyEntry(title, meta, actions = '') {
  return `<div class="history-entry"><b>${escapeHtml(title)}</b><span>${escapeHtml(meta)}</span>${actions}</div>`;
}

function renderPatientHistory(patient) {
  const role = document.getElementById('profileRole').textContent;
  const id = String(patient.id);
  const groups = [];
  const summary = [];
  if (historyAccess.appointments.includes(role)) {
    const rows = appointments.filter((item) => item.patientId === id);
    summary.push(historyCount(rows.length, 'appointment', 'appointments'));
    groups.push(`<div class="history-group"><span class="history-group-title">Appointments</span>${rows.map((item) => historyEntry(`${item.date} at ${item.time}`, `${item.id} · ${item.status[0].toUpperCase()}${item.status.slice(1)} · ${item.staff}`)).join('') || '<div class="history-empty">No appointments recorded for this patient.</div>'}</div>`);
  }
  if (historyAccess.treatments.includes(role)) {
    const rows = dockets.filter((item) => item.patientId === id);
    summary.push(historyCount(rows.length, 'treatment', 'treatments'));
    groups.push(`<div class="history-group"><span class="history-group-title">Treatments</span>${rows.map((item) => {
      const amounts = item.items.map((line) => `${line.name}${line.type === 'PRODUCT' ? ` × ${line.quantity} ${line.productUnit}` : ''}: ${line.lineTotal == null ? 'price not recorded' : `₱${line.lineTotal.toFixed(2)}`}`).join('; ');
      const total = item.total == null ? 'Total unavailable' : `Total ₱${item.total.toFixed(2)}`;
      return historyEntry(item.itemSummary, `${item.id} · ${item.created} · ${amounts} · ${total} · ${item.dermatologist} / ${item.therapist}`);
    }).join('') || '<div class="history-empty">No treatment dockets recorded for this patient.</div>'}</div>`);
  }
  if (historyAccess.consultations.includes(role)) {
    const rows = consultations.filter((item) => item.patientId === id);
    summary.push(historyCount(rows.length, 'consultation', 'consultations'));
    groups.push(`<div class="history-group"><span class="history-group-title">Consultations</span>${rows.map((item) => {
      const linkedAppointment = appointments.find((appointment) => appointment.id === item.followupAppointment);
      const activeFollowUp = Boolean(item.followupAppointment)
        && linkedAppointment?.status !== 'cancelled';
      const scheduled = activeFollowUp
        ? `Follow-up ${linkedAppointment?.date || item.followupDate}${(linkedAppointment?.time || item.followupTime) ? ` at ${timeLabel(linkedAppointment?.time || item.followupTime)}` : ''} · ${item.followupAppointment}`
        : linkedAppointment?.status === 'cancelled'
          ? `Previous follow-up ${linkedAppointment.date} at ${timeLabel(linkedAppointment.time)} · Cancelled`
        : '';
      const followUpMeta = [item.id, datePart(item.created), item.author, scheduled].filter(Boolean).join(' · ');
      const canSchedule = patient.status === 'active'
        && ['Administrator', 'Dermatologist'].includes(role)
        && (!item.followupAppointment || linkedAppointment?.status === 'cancelled');
      const action = canSchedule
        ? `<button class="history-follow-up" type="button" data-follow-up-consultation="${escapeHtml(item.dbId)}">Schedule follow-up</button>`
        : '';
      return historyEntry(item.diagnosis || 'No diagnosis recorded', followUpMeta, action);
    }).join('') || '<div class="history-empty">No consultations recorded for this patient.</div>'}</div>`);
  }
  document.getElementById('patientHistoryCount').textContent = summary.length ? summary.join(' · ') : '';
  document.getElementById('patientHistoryBody').innerHTML = groups.join('')
    || '<div class="history-empty">Clinical history is not available to your role.</div>';
}

function openPatientDetail(patient) {
  patientDetailPatientId = String(patient.id);
  document.getElementById('patientDetailName').textContent = patient.name;
  document.getElementById('patientDetailId').textContent = patient.patientNumber;
  setDetailValue('patientDetailEmail', patient.email || '—', !patient.email);
  setDetailValue('patientDetailPhone', patient.phoneDisplay || '—', !patient.phoneDisplay);
  setDetailValue('patientDetailSkinType', skinTypeLabel(patient.skinType), !patient.skinType);
  setDetailValue('patientDetailAllergies', patient.allergies || 'None recorded', !patient.allergies);
  renderPatientHistory(patient);
  openModal('patientDetailModal');
}

function scheduleConsultationFollowUp(consultation) {
  const patient = patients.find((item) => item.id === consultation.patientId);
  if (!patient || patient.status !== 'active') {
    showToast('Follow-up unavailable', 'Only active patient records can be scheduled.');
    return;
  }
  if (!['Administrator', 'Dermatologist'].includes(document.getElementById('profileRole').textContent)) {
    showToast('Authorization required', 'Only clinical roles can schedule consultation follow-ups.');
    return;
  }
  openAppointmentModal(null, { ...consultation, patientId: patient.id });
}

// The treatment docket QR hands its itemized, priced records to the external POS. It carries no
// payment or billing state; payment remains outside this system.
function openDocketQrModal(docket) {
  const staff = (name) => (name && name !== 'Unassigned' ? name : null);
  const items = docket.items.map((item) => ({
    type: item.type,
    ...(item.type === 'SERVICE'
      ? { code: item.serviceCode || null }
      : { sku: item.productSku || null, unit: item.productUnit || null }),
    name: item.name,
    quantity: item.quantity,
    unitPrice: item.unitPrice,
    lineTotal: item.lineTotal
  }));
  const payload = {
    type: 'dermaclinic.treatment-docket',
    version: 4,
    docketReference: docket.id,
    docketStatus: String(docket.status || '').toUpperCase() || null,
    patientName: docket.patient,
    patientReference: docket.patientReference || null,
    appointmentReference: staff(docket.appointment),
    currency: 'PHP',
    items,
    total: docket.total,
    assignedDermatologist: staff(docket.dermatologist),
    assignedTherapist: staff(docket.therapist),
    treatmentDate: docket.created,
    treatmentTime: docket.createdTime,
    recordedAt: docket.createdAt
  };
  const json = JSON.stringify(payload);
  const preview = document.getElementById('docketQrPreview');
  document.getElementById('docketQrTitle').textContent = docket.id;
  document.getElementById('docketQrPayload').textContent = json;
  preview.innerHTML = '';
  if (window.QRCode) new QRCode(preview, { text: json, width: 200, height: 200, correctLevel: QRCode.CorrectLevel.M, colorDark: '#243959', colorLight: '#ffffff' });
  else preview.textContent = 'QR library unavailable';
  openModal('docketQrModal');
}

function docketDetailFields(docket) {
  return {
    Patient: docket.patient,
    Docket: docket.id,
    Total: docket.total == null ? 'Not available for legacy unpriced items' : `₱${docket.total.toFixed(2)}`
  };
}

// The daily book's window. These are minutes rather than formatted strings so the boundary checks
// are arithmetic: 10:00 is 600, 22:00 is 1320, and a slot is bookable when it starts on a half hour
// and finishes by 1320. The server applies the same rule in AppointmentBook.java.
const BOOK_OPENS_MINUTES = 10 * 60;
const BOOK_CLOSES_MINUTES = 22 * 60;
const BOOK_SLOT_MINUTES = 30;

function bookSlots() {
  const slots = [];
  for (let minute = BOOK_OPENS_MINUTES; minute + BOOK_SLOT_MINUTES <= BOOK_CLOSES_MINUTES; minute += BOOK_SLOT_MINUTES) {
    slots.push(`${String(Math.floor(minute / 60)).padStart(2, '0')}:${String(minute % 60).padStart(2, '0')}`);
  }
  return slots;
}

function minutesOf(time) {
  const [hour, minute] = String(time || '').split(':').map(Number);
  return Number.isFinite(hour) && Number.isFinite(minute) ? hour * 60 + minute : null;
}

// "13:30" reads as "1:30 PM" in the book. The stored value stays 24-hour, which is what both the
// database and the time input use; only the label changes.
function timeLabel(time) {
  const minutes = minutesOf(time);
  if (minutes == null) return '';
  const hour24 = Math.floor(minutes / 60);
  const hour12 = hour24 % 12 === 0 ? 12 : hour24 % 12;
  return `${hour12}:${String(minutes % 60).padStart(2, '0')} ${hour24 < 12 ? 'AM' : 'PM'}`;
}

function formatBookDate(date) {
  const parsed = new Date(`${date}T00:00:00`);
  return Number.isNaN(parsed.getTime())
    ? date
    : new Intl.DateTimeFormat(undefined, { weekday: 'long', day: 'numeric', month: 'long', year: 'numeric' }).format(parsed);
}

/**
 * Why a slot cannot be booked, or an empty string when it can. One function serves the appointment
 * form, the follow-up form and the submit handlers, so the live warning and the message after a
 * rejected save cannot disagree.
 */
function appointmentSlotIssue({ date, time, staffId, therapistId, excludeDbId }) {
  if (!date || !time) return '';
  const start = minutesOf(time);
  if (start == null || start < BOOK_OPENS_MINUTES || start + BOOK_SLOT_MINUTES > BOOK_CLOSES_MINUTES || start % BOOK_SLOT_MINUTES !== 0) {
    return 'The clinic books 30-minute appointments from 10:00 AM to 10:00 PM. Choose a time on the half hour in that range.';
  }
  if (!staffId && !therapistId) return '';
  const end = start + BOOK_SLOT_MINUTES;
  // The comparison is on the interval, not on an equal start: a legacy appointment at 10:15 still
  // occupies part of the 10:00 slot. The appointment being edited excludes itself.
  const busy = appointments.find((appointment) => {
    if (appointment.date !== date || appointment.status === 'cancelled' || appointment.dbId === excludeDbId) return false;
    const assignedToSamePerson = (staffId && appointment.staffId === staffId) || (therapistId && appointment.therapistId === therapistId);
    if (!assignedToSamePerson) return false;
    const otherStart = minutesOf(appointment.time);
    return otherStart != null && otherStart < end && otherStart + BOOK_SLOT_MINUTES > start;
  });
  if (!busy) return '';
  const who = busy.staff && busy.staff !== 'Unassigned' ? busy.staff : 'That clinician';
  return `${who} already has an appointment at ${timeLabel(busy.time)}. Choose another slot.`;
}

function renderAppointments() {
  const dateInput = document.getElementById('appointmentBookDate');
  if (dateInput && !dateInput.value) dateInput.value = localDateKey(new Date());
  const date = dateInput?.value || localDateKey(new Date());
  const query = document.getElementById('appointmentSearch').value.trim().toLowerCase();
  const filter = document.getElementById('appointmentFilter').value;
  const dayAppointments = appointments.filter((appointment) => appointment.date === date
    && (filter === 'all' || appointment.status === filter)
    && `${appointment.patient} ${appointment.patientNumber} ${appointment.staff} ${appointment.phoneDisplay} ${appointment.notes} ${appointment.id}`.toLowerCase().includes(query));
  document.getElementById('appointmentCount').textContent = `${dayAppointments.length} appointment${dayAppointments.length === 1 ? '' : 's'} · ${formatBookDate(date)}`;

  // One card per booking. The four fields the clinic asked for come first -- name, phone, assigned
  // therapist or dermatologist, notes -- and the actions stay underneath them.
  const card = (appointment) => `<article class="appointment-card${appointment.status === 'cancelled' ? ' appointment-card-cancelled' : ''}"${appointment.status === 'cancelled' ? ' aria-label="Cancelled appointment"' : ''}>
    <div class="appointment-card-head"><b>${escapeHtml(appointment.patient)}</b><span class="patient-status ${escapeHtml(appointment.status)}">${appointment.status === 'cancelled' ? 'Cancelled' : escapeHtml(appointment.status)}</span></div>
    <div class="appointment-card-meta"><span><b>Phone</b>${escapeHtml(appointment.phoneDisplay || 'No phone recorded')}</span><span><b>Assigned</b>${escapeHtml(appointment.staff)}</span></div>
    <p class="appointment-card-notes"><b>Notes</b>${escapeHtml(appointment.notes || 'No notes')}</p>
    ${appointment.status === 'cancelled' ? '<p class="appointment-card-cancelled-note">Cancelled · This appointment remains in the schedule history.</p>' : ''}
    <div class="appointment-card-actions"><button data-appointment="view" data-id="${escapeHtml(appointment.id)}">View</button>${appointment.status === 'cancelled' ? '' : `<button data-appointment="update" data-id="${escapeHtml(appointment.id)}">Update</button>`}${appointment.status === 'completed' ? '<span class="patient-status active">Completed</span>' : appointment.status === 'cancelled' ? '' : `<button data-appointment="complete" data-id="${escapeHtml(appointment.id)}">Complete</button><button data-appointment="cancel" data-id="${escapeHtml(appointment.id)}">Cancel appointment</button>`}</div>
  </article>`;

  const slots = bookSlots();
  const booked = new Map(slots.map((slot) => [slot, []]));
  const outside = [];
  for (const appointment of dayAppointments) {
    const slot = String(appointment.time || '').slice(0, 5);
    if (booked.has(slot)) booked.get(slot).push(appointment);
    else outside.push(appointment);
  }
  document.getElementById('appointmentTable').innerHTML = slots.map((slot) => `<div class="book-slot"><time>${timeLabel(slot)}</time><div class="book-slot-entries">${booked.get(slot).length ? booked.get(slot).map(card).join('') : '<span class="book-available">Available</span>'}</div></div>`).join('')
    + (outside.length ? `<div class="book-slot book-slot-outside"><time>Outside</time><div class="book-slot-entries"><p class="book-outside-note">Outside the 10:00 AM–10:00 PM book</p>${outside.map(card).join('')}</div></div>` : '');
  renderAppointmentAlert();
}

// The sidebar badge is a count of work still to do, not of records: completed and cancelled
// appointments leave it. It counts every appointment, not just the ones the table's search box and
// status filter happen to be showing, and hides itself at zero rather than showing "0".
function renderAppointmentAlert() {
  const badge = document.querySelector('.nav-item[data-view="Appointments"] .alert-count');
  if (!badge) return;
  const open = appointments.filter((appointment) => !['completed', 'cancelled'].includes(appointment.status)).length;
  badge.textContent = String(open);
  badge.hidden = open === 0;
}

function openAppointmentModal(appointment, followUpConsultation) {
  // The database id, not the APT- number: the edit route addresses the row by id, and a request to
  // /api/clinic/appointments/APT-XXXX falls through to "One of the supplied identifiers was not a
  // valid number." The number stays the display key everywhere else.
  editingAppointmentId = appointment?.dbId || null;
  followUpConsultationId = followUpConsultation?.dbId || null;
  const isFollowUp = Boolean(followUpConsultation);
  const isDermatologistFollowUp = isFollowUp && document.getElementById('profileRole').textContent === 'Dermatologist';
  document.getElementById('appointmentModalTitle').textContent = isFollowUp ? 'Schedule follow-up' : appointment ? 'Update appointment' : 'Create appointment';
  document.getElementById('appointmentSubmitButton').textContent = isFollowUp ? 'Schedule follow-up' : appointment ? 'Save changes' : 'Create appointment';
  openModal('appointmentModal');
  populateClinicalPatients();
  // A new booking starts on the day the book is showing, which is the day the receptionist is
  // looking at. An edit keeps the appointment's own date and time.
  const bookDate = document.getElementById('appointmentBookDate')?.value || localDateKey(new Date());
  const patientInput = document.getElementById('appointmentPatient');
  patientInput.disabled = isFollowUp;
  patientInput.value = followUpConsultation?.patientId || appointment?.patientId || patients[0]?.id || '';
  document.getElementById('appointmentDate').value = appointment?.date || bookDate;
  document.getElementById('appointmentTime').value = appointment?.time || '';
  document.getElementById('appointmentStaff').value = appointment ? `${appointment.staffId}` : isDermatologistFollowUp ? currentUserId || '' : document.getElementById('appointmentStaff').options[0]?.value || '';
  document.getElementById('appointmentTherapist').value = appointment ? `${appointment.therapistId}` : '';
  document.getElementById('appointmentAssignmentFields').hidden = isDermatologistFollowUp;
  document.getElementById('appointmentNotes').value = followUpConsultation
    ? `Follow-up for consultation ${followUpConsultation.id}`
    : appointment?.notes || '';
  document.getElementById('appointmentError').textContent = '';
  updateAppointmentWarning();
}

// Re-evaluated on every field change in the form, so the warning appears before the receptionist
// commits to a slot rather than only after the server rejects the save.
function updateAppointmentWarning() {
  const warning = document.getElementById('appointmentWarning');
  if (!warning) return;
  const issue = appointmentSlotIssue({
    date: document.getElementById('appointmentDate').value,
    time: document.getElementById('appointmentTime').value,
    staffId: document.getElementById('appointmentStaff').value,
    therapistId: document.getElementById('appointmentTherapist').value,
    excludeDbId: editingAppointmentId
  });
  warning.textContent = issue;
  warning.hidden = !issue;
}

// The follow-up is booked against the signing clinician, which is the same account the server
// assigns it to. The current user comes from the staff list already loaded for the role.
function updateConsultationWarning() {
  const warning = document.getElementById('consultationWarning');
  if (!warning) return;
  const date = document.getElementById('followupDateInput').value;
  const time = document.getElementById('followupTimeInput').value;
  if (!date && !time) {
    warning.textContent = '';
    warning.hidden = true;
    return;
  }
  if (!date || !time) {
    warning.textContent = 'A follow-up appointment needs both a date and a time.';
    warning.hidden = false;
    return;
  }
  const issue = appointmentSlotIssue({ date, time, staffId: currentUserId, therapistId: '', excludeDbId: null });
  warning.textContent = issue;
  warning.hidden = !issue;
}

async function loadSuppliers() {
  const records = await apiRequest('/api/clinic/suppliers');
  suppliers.splice(0, suppliers.length, ...records.map((record) => ({
    id: String(record.id), code: record.code || '', name: record.name || '',
    email: record.email || '', phone: record.phone || '',
    // `products` arrives as one comma-joined string rather than a list, because the supplier list is a
    // single query. Split it back out here so the templates below can count and escape it properly;
    // an empty string means the supplier has no active products, not one product called "".
    productNames: String(record.products || '').split(', ').filter((name) => name.length > 0),
    products: Number(record.productCount || 0), status: String(record.status || 'ACTIVE').toLowerCase()
  })));
}

function renderSuppliers() {
  document.getElementById('supplierList').innerHTML = suppliers.length
    ? suppliers.map((supplier) => `<div class="supplier-row" data-supplier-id="${escapeHtml(supplier.id)}"><div class="supplier-row-main"><b>${escapeHtml(supplier.name)}</b><span>${escapeHtml(supplier.code)} · ${escapeHtml(supplier.email || 'No email recorded')} · ${supplier.products} product${supplier.products === 1 ? '' : 's'}</span></div><div class="supplier-row-products"><small>Products supplied</small><span>${supplier.productNames.length ? escapeHtml(supplier.productNames.join(', ')) : 'No products assigned yet'}</span></div></div>`).join('')
    : '<div class="patient-empty">No suppliers recorded yet.</div>';
}

// The Add New Product form can only offer active suppliers, because the backend refuses to attach a
// product to an archived one. Rebuilding the options on every open keeps the list honest after a
// supplier is added while the inventory workspace is already on screen.
function populateProductSupplierOptions() {
  const select = document.getElementById('productSupplier');
  const previous = select.value;
  select.innerHTML = '<option value="">Select a supplier</option>'
    + suppliers.filter((supplier) => supplier.status === 'active').map((supplier) => `<option value="${escapeHtml(supplier.id)}">${escapeHtml(supplier.name)}${supplier.code ? ` · ${escapeHtml(supplier.code)}` : ''}</option>`).join('');
  if (previous && select.querySelector(`option[value="${CSS.escape(previous)}"]`)) select.value = previous;
}

async function loadArchivedProducts() {
  const records = await apiRequest('/api/clinic/inventory/archived');
  return records.map((item) => ({ id: String(item.id), name: item.name, sku: item.sku, unit: item.unit || '', supplier: item.supplier || 'Unassigned', stock: Number(item.stock || 0) }));
}

function renderArchivedProducts(products) {
  document.getElementById('archivedProductsList').innerHTML = products.length
    ? products.map((product) => `<div class="patient-row"><div class="patient-person"><div class="patient-avatar">□</div><div><b>${escapeHtml(product.name)}</b><span>${escapeHtml(product.sku)} · ${escapeHtml(product.supplier)}</span></div></div><div class="patient-contact">${escapeHtml(product.stock)} ${escapeHtml(product.unit)}<small>Kept for historical records</small></div><span class="patient-status archived">Archived</span><div class="patient-actions"><button data-archived="restore" data-id="${escapeHtml(product.id)}">Restore</button></div></div>`).join('')
    : '<div class="patient-empty">No archived products. Nothing has been removed from the catalogue.</div>';
}


function renderConsultations() {
  document.getElementById('consultationTable').innerHTML = consultations.map((consultation) => {
    // The date and time are what put the follow-up on the receptionist's schedule; the appointment
    // number is shown beside them so the two records can be matched without opening the book.
    const scheduled = consultation.followupDate
      ? `${consultation.followupDate}${consultation.followupTime ? ` at ${timeLabel(consultation.followupTime)}` : ''}${consultation.followupAppointment ? ` · ${consultation.followupAppointment}` : ''}`
      : '';
    const followUp = [scheduled, consultation.followup].filter(Boolean).join(' · ') || 'No follow-up scheduled';
    // Clinical notes are no longer collected. Older consultations may still have them, so the row
    // is rendered only when there is text, rather than as an empty label on every new entry.
    const notesRow = consultation.notes ? `<b>Notes</b><span>${escapeHtml(consultation.notes)}</span>` : '';
    return `<div class="consultation-entry"><div class="consultation-meta"><b>${escapeHtml(consultation.patient)}</b><span>${escapeHtml(consultation.id)} · ${escapeHtml(consultation.created)}</span></div><div class="consultation-copy"><b>Diagnosis</b><span>${escapeHtml(consultation.diagnosis)}</span><b>Recommendation</b><span>${escapeHtml(consultation.recommendation)}</span>${notesRow}<b>Follow-up</b><span>${escapeHtml(followUp)}</span></div><div class="audit-stamp">Immutable entry<br />${escapeHtml(consultation.author)}</div></div>`;
  }).join('') || '<div class="patient-empty">No consultations recorded yet. Completed consultations appear here as immutable entries.</div>';
}

function populateClinicalPatients() {
  // The consultation dropdown leads with a blank option so the form can genuinely start with no patient
  // chosen, which is what makes the submit handler's "Select a patient before saving the consultation."
  // reachable. The appointment dropdown deliberately does not get one: openAppointmentModal assigns its
  // patient explicitly after calling this, and its own guard counts options.length to tell "nothing
  // chosen" apart from "there are no active patients".
  const activePatients = patients.filter((patient) => patient.status === 'active');
  const patientOptions = (withPlaceholder) => (withPlaceholder ? '<option value="">Select a patient</option>' : '') + activePatients.map((patient) => `<option value="${escapeHtml(patient.id)}">${escapeHtml(patient.name)} · ${escapeHtml(patient.patientNumber)}</option>`).join('');
  document.getElementById('appointmentPatient').innerHTML = patientOptions(false);
  document.getElementById('consultationPatient').innerHTML = patientOptions(true);
  const staff = users.filter((user) => user.active && user.role === 'Dermatologist');
  // The value is the user id, not the label. The booking endpoint assigns by id, and the label reads
  // "Dr. Jem · Dermatologist" -- which the server cannot resolve to an account, so sending the label
  // made every create fail with "Select an assigned staff member." even with a name on screen.
  document.getElementById('appointmentStaff').innerHTML = '<option value="">No dermatologist</option>'
    + staff.map((user) => `<option value="${escapeHtml(user.id)}">${escapeHtml(user.name)} · ${escapeHtml(user.role)}</option>`).join('');
  document.getElementById('appointmentTherapist').innerHTML = '<option value="">No therapist</option>'
    + therapists.filter((therapist) => therapist.status === 'active').map((therapist) => `<option value="${escapeHtml(therapist.id)}">${escapeHtml(therapist.name)}</option>`).join('');
  document.getElementById('docketDermatologist').innerHTML = staff.map((user) => `<option value="${escapeHtml(user.id)}">${escapeHtml(user.name)}</option>`).join('');
  document.getElementById('docketTherapist').innerHTML = therapists.filter((therapist) => therapist.status === 'active').map((therapist) => `<option value="${escapeHtml(therapist.id)}">${escapeHtml(therapist.name)}</option>`).join('');
}

function renderDockets() {
  const query = document.getElementById('docketSearch').value.toLowerCase();
  const rows = dockets.filter((docket) => `${docket.id} ${docket.patient} ${docket.itemSummary}`.toLowerCase().includes(query));
  document.getElementById('docketCount').textContent = `${rows.length} treatment docket${rows.length === 1 ? '' : 's'}`;
  document.getElementById('docketTable').innerHTML = rows.map((docket) => {
    const itemLines = docket.items.map((item) => {
      const type = item.type === 'PRODUCT' ? 'Retail product' : 'Treatment service';
      const quantity = item.type === 'PRODUCT' ? ` · ${item.quantity} ${item.productUnit}` : '';
      const amount = item.lineTotal == null ? 'Price not recorded' : `₱${item.lineTotal.toFixed(2)}`;
      return `<span class="docket-summary-line"><b>${escapeHtml(item.name)}</b><small>${escapeHtml(type)}${escapeHtml(quantity)} · ${escapeHtml(amount)}</small></span>`;
    }).join('');
    const total = docket.total == null ? 'Total unavailable' : `Total · ₱${docket.total.toFixed(2)}`;
    return `<div class="docket-record-row"><div class="docket-record-patient"><div class="patient-avatar lavender">▤</div><b>${escapeHtml(docket.patient)}</b><small>${escapeHtml(docket.id)}</small></div><div class="docket-record-items">${itemLines}<b class="docket-record-total">${escapeHtml(total)}</b></div><div class="patient-actions"><button data-docket="preview" data-id="${escapeHtml(docket.id)}">Preview</button><button data-docket="print" data-id="${escapeHtml(docket.id)}">Print</button><button data-docket="qr" data-id="${escapeHtml(docket.id)}">POS QR</button></div></div>`;
  }).join('') || '<div class="patient-empty">No treatment dockets match your filters.</div>';
}

function salesRangeLabel(from, to) {
  if (from && to) return `${from} to ${to}`;
  if (from) return `from ${from}`;
  if (to) return `up to ${to}`;
  return 'all recorded dates';
}

// Sales Management is a service-sales report, not a financial one. Retail product lines are outside
// this report. Nothing monetary is read or derived: the external POS owns payment, receipts,
// refunds and paid status, and none of those fields appear here.
function renderSales() {
  const from = document.getElementById('salesDateFrom').value;
  const to = document.getElementById('salesDateTo').value;
  const count = document.getElementById('salesCount');
  const table = document.getElementById('salesTable');
  if (from && to && from > to) {
    count.textContent = 'The Date From value is after the Date To value.';
    document.getElementById('salesServiceCount').textContent = '—';
    document.getElementById('salesQuantity').textContent = '—';
    table.innerHTML = '<div class="patient-empty">Choose a date range where Date From is on or before Date To.</div>';
    return;
  }
  // docket.created is already a local YYYY-MM-DD key, so the comparison stays on the clinic's own
  // calendar and never shifts a late-evening sale into the next day. A docket without a date cannot
  // be placed in a dated report and is left out rather than compared as an empty string.
  const inRange = (date) => Boolean(date) && (!from || date >= from) && (!to || date <= to);
  const byService = new Map();
  dockets.filter((docket) => docket.status !== 'cancelled' && inRange(docket.created))
    .forEach((docket) => docket.items.filter((item) => item.type === 'SERVICE').forEach((item) => {
      const key = item.serviceId || item.name;
      const row = byService.get(key) || { service: item.name || 'Service removed', quantity: 0 };
      row.quantity += item.quantity;
      byService.set(key, row);
    }));
  const rows = [...byService.values()].sort((left, right) => left.service.localeCompare(right.service));
  const quantity = rows.reduce((sum, row) => sum + row.quantity, 0);
  document.getElementById('salesServiceCount').textContent = rows.length;
  document.getElementById('salesQuantity').textContent = quantity;
  count.textContent = rows.length
    ? `${rows.length} service${rows.length === 1 ? '' : 's'} · ${quantity} sold · ${salesRangeLabel(from, to)}`
    : `No service sales ${from || to ? `for ${salesRangeLabel(from, to)}` : 'recorded yet'}`;
  table.innerHTML = rows.map((row) => `<div class="sales-table-row"><b>${escapeHtml(row.service)}</b><span class="sales-quantity">${escapeHtml(row.quantity)}</span></div>`).join('')
    || '<div class="patient-empty">No service sales match this date range.</div>';
}

function renderServices() {
  const filter = document.getElementById('serviceStatusFilter').value;
  const rows = services.filter((service) => filter === 'all' || service.status === filter);
  document.getElementById('serviceCount').textContent = `${rows.length} ${filter === 'all' ? '' : filter} service${rows.length === 1 ? '' : 's'}`;
  // Category and description are no longer collected on the form. Existing records keep whatever
  // they already have, so they are shown only when present; a new service shows its code alone and
  // no empty description line.
  document.getElementById('serviceTable').innerHTML = rows.map((service) => {
    const meta = [service.code, service.category].filter(Boolean).join(' · ');
    const description = service.description ? `<small>${escapeHtml(service.description)}</small>` : '';
    return `<div class="patient-row"><div class="patient-person"><div class="patient-avatar mint">◇</div><div><b>${escapeHtml(service.name)}</b><span>${escapeHtml(meta)}</span></div></div><div class="patient-contact">₱${escapeHtml(service.price)} · ${escapeHtml(service.duration)} min${description}</div><span class="patient-status ${escapeHtml(service.status)}">${escapeHtml(service.status)}</span><div class="patient-actions"><button data-service="edit" data-id="${escapeHtml(service.id)}">Edit</button><button data-service="archive" data-id="${escapeHtml(service.id)}">${service.status === 'active' ? 'Archive' : 'Restore'}</button></div></div>`;
  }).join('') || '<div class="patient-empty">No services match this filter.</div>';
}

function populateDocketForm() {
  populateClinicalPatients();
  document.getElementById('docketPatient').innerHTML = patients.filter((patient) => patient.status === 'active').map((patient) => `<option value="${escapeHtml(patient.id)}">${escapeHtml(patient.name)} · ${escapeHtml(patient.patientNumber)}</option>`).join('');
  document.getElementById('docketLines').innerHTML = '';
  addDocketLine('SERVICE');
}

function addDocketLine(type) {
  const row = document.createElement('div');
  row.className = 'docket-line-row';
  row.dataset.type = type;
  const servicesOptions = services.filter((service) => service.status === 'active')
    .map((service) => `<option value="${escapeHtml(service.id)}">${escapeHtml(service.name)} · ₱${service.price.toFixed(2)}</option>`).join('');
  const retailProducts = inventory.filter((item) => item.usageType === 'RETAIL');
  const productOptions = retailProducts
    .map((item) => `<option value="${escapeHtml(item.id)}">${escapeHtml(item.name)} · ${escapeHtml(item.sku)} · ${escapeHtml(item.stock)} ${escapeHtml(item.unit)} available</option>`).join('');
  if (type === 'SERVICE') {
    row.innerHTML = `<label>Treatment service<select data-docket-service>${servicesOptions || '<option value="">No active service</option>'}</select></label><span class="docket-line-amount">₱0.00</span><button class="docket-line-remove" type="button" aria-label="Remove treatment service" data-remove-docket-line>Remove</button>`;
  } else {
    row.innerHTML = `<label>Retail product<select data-docket-product>${productOptions || '<option value="">No active retail product</option>'}</select></label><label>Quantity<input data-docket-quantity type="number" min="0.001" step="0.001" value="1" required /></label><label>Unit price (₱)<input data-docket-price type="number" min="0" step="0.01" placeholder="Enter price" required /></label><span class="docket-line-amount">Enter price</span><button class="docket-line-remove" type="button" aria-label="Remove retail product" data-remove-docket-line>Remove</button>`;
  }
  document.getElementById('docketLines').append(row);
  updateDocketCalculation();
}

function costingTable(rows) {
  if (!rows.length) return '<small class="inventory-ok">No products are required for this service.</small>';
  return `<div class="costing-scroll"><table class="costing-table"><thead><tr><th>Product name</th><th>Required quantity</th><th>Available quantity</th></tr></thead><tbody>${rows.map((row) => `<tr><td>${escapeHtml(row.name)}</td><td>${escapeHtml(row.required)}</td><td class="${row.sufficient ? 'inventory-ok' : 'inventory-error'}">${escapeHtml(row.available)}</td></tr>`).join('')}</tbody></table></div>`;
}

function docketDecimalHasPrecision(value, maxDecimals) {
  const text = String(value).trim();
  if (!/^(?:\d+(?:\.\d*)?|\.\d+)$/.test(text)) return false;
  return (text.split('.')[1] || '').length <= maxDecimals;
}

function docketLineData() {
  const items = [];
  const errors = [];
  const requiredByProduct = new Map();
  let total = 0;
  let totalKnown = true;
  for (const row of document.querySelectorAll('#docketLines .docket-line-row')) {
    if (row.dataset.type === 'SERVICE') {
      const service = services.find((item) => item.id === row.querySelector('[data-docket-service]').value && item.status === 'active');
      if (!service) {
        errors.push('Select an active treatment service for every service line.');
        row.querySelector('.docket-line-amount').textContent = 'Select service';
        continue;
      }
      items.push({ type: 'SERVICE', serviceId: service.dbId });
      total += service.price;
      service.products.forEach((requirement) => {
        const key = requirement.productId;
        const current = requiredByProduct.get(key) || { product: inventory.find((item) => item.id === key), quantity: 0 };
        current.quantity += requirement.quantity;
        requiredByProduct.set(key, current);
      });
      row.querySelector('.docket-line-amount').textContent = `₱${service.price.toFixed(2)}`;
      continue;
    }
    const productId = row.querySelector('[data-docket-product]').value;
    const product = inventory.find((item) => item.id === productId && item.usageType === 'RETAIL');
    const quantityValue = row.querySelector('[data-docket-quantity]').value.trim();
    const quantity = Number(quantityValue);
    const priceValue = row.querySelector('[data-docket-price]').value.trim();
    const unitPrice = Number(priceValue);
    if (!product) errors.push('Select an active retail product for every product line.');
    if (!Number.isFinite(quantity) || quantity <= 0 || !docketDecimalHasPrecision(quantityValue, 3)) errors.push('Enter a valid product quantity greater than zero (up to three decimal places).');
    if (!priceValue || !Number.isFinite(unitPrice) || unitPrice < 0 || !docketDecimalHasPrecision(priceValue, 2)) errors.push('Enter a retail unit price with up to two decimal places.');
    if (!product || !Number.isFinite(quantity) || quantity <= 0 || !priceValue || !Number.isFinite(unitPrice) || unitPrice < 0) {
      row.querySelector('.docket-line-amount').textContent = priceValue ? 'Check quantity' : 'Enter price';
      totalKnown = false;
      continue;
    }
    const lineTotal = Math.round((unitPrice * quantity + Number.EPSILON) * 100) / 100;
    items.push({ type: 'PRODUCT', productId: product.id, quantity, unitPrice });
    total += lineTotal;
    const current = requiredByProduct.get(product.id) || { product, quantity: 0 };
    current.quantity += quantity;
    requiredByProduct.set(product.id, current);
    row.querySelector('.docket-line-amount').textContent = `₱${lineTotal.toFixed(2)}`;
  }
  const stockRows = [...requiredByProduct.values()].map(({ product, quantity }) => ({
    name: product ? product.name : 'Product no longer in inventory',
    required: product ? `${quantity} ${product.unit}` : String(quantity),
    available: product ? `${product.stock} ${product.unit}` : 'Not in inventory',
    sufficient: Boolean(product) && Number(product.stock) >= quantity
  }));
  if (stockRows.some((row) => !row.sufficient)) errors.push('One or more items do not have enough available stock.');
  return { items, errors, stockRows, total: totalKnown ? total : null };
}

function updateDocketCalculation() {
  const calculation = document.getElementById('docketCalculation');
  if (!calculation) return;
  const docket = docketLineData();
  const total = docket.total == null ? '—' : `₱${docket.total.toFixed(2)}`;
  const stock = docket.stockRows.length ? costingTable(docket.stockRows) : '<small class="inventory-ok">No product stock is required.</small>';
  const warning = docket.errors.length ? `<small class="inventory-error">${escapeHtml([...new Set(docket.errors)].join(' '))}</small>` : '<small class="inventory-ok">All item stock requirements are available.</small>';
  calculation.innerHTML = `<div class="docket-line-total"><span>Docket total</span><b>${total}</b></div>${stock}${warning}`;
}

// The four remarks the server computes, in the order it applies them. Mapping the code to words and
// to a status class here keeps the inventory list, stock alerts and dashboard describing the same
// row the same way.
const stockStatusMeta = {
  IN_STOCK: { label: 'In stock', className: 'active' },
  LOW_STOCK: { label: 'Low stock', className: 'pending' },
  NEARLY_EXPIRED: { label: 'Nearly expired', className: 'pending' },
  EXPIRED: { label: 'Expired', className: 'cancelled' }
};
function stockStatusOf(item) {
  return stockStatusMeta[item.stockStatus] || { label: 'In stock', className: 'active' };
}
const usageLabels = { CLINIC: 'Clinic use', RETAIL: 'Retail use' };
// Which shelf the inventory records table is showing. The stock-alert list is not filtered by it.
let inventoryUsage = 'ALL';
let viewingProductId = null;

function renderInventory() {
  const query = document.getElementById('inventorySearch').value.toLowerCase();
  const filter = document.getElementById('inventoryFilter').value;
  const rows = inventory.filter((item) => {
    if (inventoryUsage !== 'ALL' && item.usageType !== inventoryUsage) return false;
    const matchesText = `${item.name} ${item.sku} ${item.supplier}`.toLowerCase().includes(query);
    const matchesFilter = filter === 'all'
      || (filter === 'low' && item.stockStatus === 'LOW_STOCK')
      || (filter === 'expiring' && (item.stockStatus === 'NEARLY_EXPIRED' || item.stockStatus === 'EXPIRED'));
    return matchesText && matchesFilter;
  });
  document.getElementById('inventoryCount').textContent = `${rows.length} product record${rows.length === 1 ? '' : 's'}`;
  document.getElementById('inventoryUsageTag').textContent = inventoryUsage === 'ALL' ? 'All stock' : usageLabels[inventoryUsage];
  // Removing a product from the catalogue is an Administrator action, matching the archive endpoint.
  // Inventory Staff can still create and adjust products; they just cannot remove one.
  const canArchive = document.getElementById('profileRole').textContent === 'Administrator';
  document.getElementById('archivedProductsButton').hidden = !canArchive;
  // The records table asks for exactly two things, a supplier and a product. Everything else about
  // the row -- code, quantity, expiry, remark -- belongs to the product view the row opens.
  document.getElementById('inventoryTable').innerHTML = rows.map((item) => {
    const supplier = item.supplierId
      ? `<button class="inventory-supplier-link" data-supplier-view="${escapeHtml(item.supplierId)}">${escapeHtml(item.supplier)}</button>`
      : `<span>${escapeHtml(item.supplier)}</span>`;
    return `<div class="inventory-record-row">${supplier}<button class="inventory-product-link" data-product-view="${escapeHtml(item.id)}">${escapeHtml(item.name)}</button></div>`;
  }).join('') || '<div class="patient-empty">No inventory records match your filters.</div>';
  renderStockAlerts();
  document.getElementById('movementTable').innerHTML = movements.map((movement) => `<div class="movement-row"><b>${escapeHtml(movement.product)}<small class="movement-usage">${escapeHtml(usageLabels[movement.usageType] || usageLabels.CLINIC)}</small></b><span class="movement-type ${movement.type === 'Stock In' ? 'stockin' : 'stockout'}">${escapeHtml(movement.type)}</span><span>${escapeHtml(movement.supplier)}</span><span>${escapeHtml(movement.quantity > 0 ? '+' : '')}${escapeHtml(movement.quantity)}</span><time>${escapeHtml(movement.time)}</time></div>`).join('') || '<div class="patient-empty">No stock movements recorded yet. Movements appear here when stock is received or withdrawn.</div>';
}

// The alert list spans both shelves on purpose: a retail product that has expired is still something
// the front desk must act on while the records table is showing clinic-use stock.
const stockAlertRank = { EXPIRED: 0, NEARLY_EXPIRED: 1, LOW_STOCK: 2 };
function renderStockAlerts() {
  const alerts = inventory
    .filter((item) => stockAlertRank[item.stockStatus] != null)
    .sort((a, b) => (stockAlertRank[a.stockStatus] - stockAlertRank[b.stockStatus]) || a.name.localeCompare(b.name));
  document.getElementById('stockAlertCount').textContent = alerts.length
    ? `${alerts.length} product${alerts.length === 1 ? '' : 's'} need attention`
    : 'No stock alerts';
  document.getElementById('stockAlertsTable').innerHTML = alerts.map((item) => {
    const status = stockStatusOf(item);
    return `<div class="stock-alert-row"><span>${escapeHtml(item.supplier)}</span><button class="inventory-product-link" data-product-view="${escapeHtml(item.id)}">${escapeHtml(item.name)}</button><span class="patient-status ${status.className}">${status.label}</span><b>${escapeHtml(item.stock)} ${escapeHtml(item.unit)}</b></div>`;
  }).join('') || '<div class="patient-empty">Every product is in stock and none is expiring within 30 days.</div>';
}

// Product view: the fields the inventory record is described by when the row is opened. Actions that
// used to live on every row now live here, so the records table itself shows only supplier and product.
function openProductView(item) {
  const status = stockStatusOf(item);
  viewingProductId = item.id;
  document.getElementById('productViewTitle').textContent = item.name;
  document.getElementById('productViewName').textContent = item.name;
  document.getElementById('productViewCode').textContent = item.sku;
  document.getElementById('productViewQuantity').textContent = `${item.stock} ${item.unit}`;
  document.getElementById('productViewExpiry').textContent = item.expiry || 'No expiry recorded';
  document.getElementById('productViewStatus').innerHTML = `<span class="patient-status ${status.className}">${status.label}</span>`;
  document.getElementById('productViewUsage').textContent = usageLabels[item.usageType] || usageLabels.CLINIC;
  document.querySelector('#productViewModal [data-product-action="archive"]').hidden =
    document.getElementById('profileRole').textContent !== 'Administrator';
  openModal('productViewModal');
}

function openInventoryHistory(item) {
  const history = movements.filter((movement) => movement.product === item.name);
  document.getElementById('inventoryHistoryTitle').textContent = item.name;
  document.getElementById('inventoryHistorySummary').textContent = `${item.stock} ${item.unit} on hand · batch ${item.batch} · ${history.length} recorded movement${history.length === 1 ? '' : 's'}`;
  document.getElementById('inventoryHistoryTable').innerHTML = history.map((movement) => `<div class="movement-row"><b>${escapeHtml(movement.product)}<small class="movement-usage">${escapeHtml(usageLabels[movement.usageType] || usageLabels.CLINIC)}</small></b><span class="movement-type ${movement.type === 'Stock In' ? 'stockin' : 'stockout'}">${escapeHtml(movement.type)}</span><span>${escapeHtml(movement.supplier)}</span><span>${escapeHtml(movement.quantity > 0 ? '+' : '')}${escapeHtml(movement.quantity)}</span><time>${escapeHtml(movement.time)}</time></div>`).join('') || '<div class="patient-empty">No stock movements recorded for this product yet.</div>';
  openModal('inventoryHistoryModal');
}

// Deleting the row outright would be refused by the database or would take stock history with it, so
// this archives instead. The dialog therefore spells out what is retained rather than implying the
// data is gone. The counts come from what is already on screen, so they can only understate the real
// number of references, never invent one.
async function archiveInventoryProduct(item) {
  if (document.getElementById('profileRole').textContent !== 'Administrator') {
    showToast('Authorization required', 'Only an Administrator can remove a product from the catalogue.');
    return;
  }
  const recordedMovements = movements.filter((movement) => movement.product === item.name).length;
  const linkedServices = services.filter((service) => service.products.some((requirement) => requirement.productId === item.id)).map((service) => service.name);
  const consequences = [
    `${item.name} (${item.sku}) disappears from the inventory list, but its record and every stock movement recorded against it are kept.`,
    item.stock > 0 ? `It still holds ${item.stock} ${item.unit} on hand, and that balance is frozen while it is archived.` : '',
    recordedMovements ? `It has ${recordedMovements} stock movement${recordedMovements === 1 ? '' : 's'} in its history, which stay viewable.` : '',
    linkedServices.length ? `It is required by ${linkedServices.length} service${linkedServices.length === 1 ? '' : 's'} (${linkedServices.join(', ')}); those requirements are kept and will need a replacement product.` : '',
    'You can bring it back at any time from Archived products.'
  ].filter(Boolean).join(' ');
  if (!await confirmAction({ title: 'Remove this product?', message: consequences, confirmLabel: 'Yes, archive product' })) return;
  try {
    await apiRequest(`/api/clinic/products/${encodeURIComponent(item.id)}/archive`, { method: 'PATCH' });
    await loadClinicData(document.getElementById('profileRole').textContent);
    renderInventory();
    renderSuppliers();
    showToast('Product archived', `${item.name} was removed from the active inventory list and its history was kept.`);
  } catch (error) {
    showToast('Product not archived', saveErrorMessage(error, 'The product could not be archived.'));
  }
}

// One delegated handler for the three places a product or supplier can be opened from. The records
// table and the stock alerts both name the product; the supplier link jumps to that partner's row in
// the supplier view and lists what it supplies.
function handleInventoryRecordClick(event) {
  const productButton = event.target.closest('[data-product-view]');
  if (productButton) {
    const item = inventory.find((record) => record.id === productButton.dataset.productView);
    if (item) openProductView(item);
    return;
  }
  const supplierButton = event.target.closest('[data-supplier-view]');
  if (supplierButton) openSupplierView(supplierButton.dataset.supplierView);
}

async function openSupplierView(supplierId) {
  try {
    await loadSuppliers();
  } catch (error) {
    showToast('Suppliers unavailable', saveErrorMessage(error, 'The supplier list could not be loaded.'));
    return;
  }
  renderSuppliers();
  openModal('supplierModal');
  const row = document.querySelector(`#supplierList [data-supplier-id="${CSS.escape(supplierId)}"]`);
  if (row) {
    row.classList.add('highlight');
    row.scrollIntoView({ block: 'nearest' });
  }
}

// The product supplier is a fact about the chosen product, so the field follows the picker instead of
// being typed. Expiry is asked for only on Stock In: a withdrawal has no new delivery to date.
function updateMovementFields() {
  const item = inventory.find((entry) => entry.id === document.getElementById('movementProduct').value);
  const stockIn = document.getElementById('movementType').value !== 'out';
  document.getElementById('movementSupplier').value = item ? item.supplier : '';
  document.getElementById('movementExpiryField').hidden = !stockIn;
  document.getElementById('movementExpiry').required = stockIn;
  if (!stockIn) document.getElementById('movementExpiry').value = '';
}

function populateMovementForm(productId) {
  // The two shelves are grouped rather than mixed, so stock cannot be moved against the wrong kind of
  // product by picking the wrong row. A shelf with no products is omitted instead of shown empty.
  const group = (usageType, label) => {
    const options = inventory.filter((item) => item.usageType === usageType).map((item) => `<option value="${escapeHtml(item.id)}" ${item.id === productId ? 'selected' : ''}>${escapeHtml(item.name)} · ${escapeHtml(item.stock)} ${escapeHtml(item.unit)} available</option>`).join('');
    return options ? `<optgroup label="${label}">${options}</optgroup>` : '';
  };
  document.getElementById('movementProduct').innerHTML = group('CLINIC', 'Clinic-use stock') + group('RETAIL', 'Retail-use stock');
  updateMovementFields();
}
document.getElementById('movementProduct').addEventListener('change', updateMovementFields);
document.getElementById('movementType').addEventListener('change', updateMovementFields);

function syncProductExpiryRequirement() {
  const quantity = Number(document.getElementById('productQuantity').value);
  document.getElementById('productExpiry').required = Number.isFinite(quantity) && quantity > 0;
}
document.getElementById('productQuantity').addEventListener('input', syncProductExpiryRequirement);

document.getElementById('newProductButton').addEventListener('click', async () => {
  document.getElementById('productForm').reset();
  syncProductExpiryRequirement();
  document.getElementById('productError').textContent = '';
  // A product cannot be saved without a supplier, so make sure the picker actually has options to
  // offer. Suppliers are loaded during sign-in for the roles that reach this screen; the retry covers
  // the case where that first request failed or the list is simply stale.
  if (!suppliers.some((supplier) => supplier.status === 'active')) {
    await loadSuppliers().catch(() => {});
  }
  populateProductSupplierOptions();
  openModal('productModal');
});
document.getElementById('productForm').addEventListener('submit', async (event) => {
  event.preventDefault();
  const name = document.getElementById('productName').value.trim();
  const sku = document.getElementById('productSku').value.trim();
  const unit = document.getElementById('productUnit').value;
  const supplierId = document.getElementById('productSupplier').value;
  const usageType = document.getElementById('productUsage').value;
  const quantityText = document.getElementById('productQuantity').value.trim();
  const quantity = Number(quantityText);
  const expiry = document.getElementById('productExpiry').value;
  const reorderThreshold = Number(document.getElementById('productReorder').value);
  const error = document.getElementById('productError');
  if (!name || !sku || !unit || quantityText === '' || !Number.isFinite(quantity) || quantity < 0
    || !Number.isFinite(reorderThreshold) || reorderThreshold < 0) {
    error.textContent = 'Enter a product name, product code, measurement unit, a quantity of zero or more, and a non-negative reorder threshold.';
    return;
  }
  if (quantity > 0 && !expiry) {
    error.textContent = 'Enter the expiration date for the opening stock.';
    return;
  }
  if (!supplierId) {
    error.textContent = suppliers.some((supplier) => supplier.status === 'active')
      ? 'Select the supplier that provides this product.'
      : 'No active supplier is available yet. Add a supplier first, then register the product.';
    return;
  }
  try {
    await apiRequest('/api/clinic/products', { method: 'POST', body: JSON.stringify({ name, sku, unit, supplierId: Number(supplierId), reorderThreshold, usageType, quantity, ...(quantity > 0 ? { expiry } : {}) }) });
    closeModal('productModal');
    await loadClinicData(document.getElementById('profileRole').textContent);
    renderInventory();
    renderSuppliers();
    showToast('Product saved', quantity > 0
      ? `The product was added and ${quantity} ${unit} recorded as opening stock.`
      : 'The product was added to the inventory catalogue and assigned to its supplier.');
  } catch (requestError) {
    error.textContent = saveErrorMessage(requestError, 'The product could not be saved.');
  }
});

function renderReports() {
  const days = Number(document.getElementById('reportDateFilter').value) || 30;
  const cutoff = new Date();
  cutoff.setDate(cutoff.getDate() - days);
  const withinRange = (value) => {
    const date = new Date(value);
    return !Number.isNaN(date.getTime()) && date >= cutoff;
  };
  const period = days === 365 ? 'this year' : `last ${days} days`;
  const rangeMovements = movements.filter((movement) => withinRange(movement.time));
  document.getElementById('reportProducts').textContent = `${inventory.length} products`;
  document.getElementById('reportStock').textContent = `${inventory.reduce((sum, item) => sum + item.stock, 0)} total units`;
  // The two shelves are reported separately as well as together, so a retail shortfall is not hidden
  // inside a clinic-use total. Units are summed per shelf, not across mixed measurement units.
  const shelfTotals = (usageType) => {
    const rows = inventory.filter((item) => item.usageType === usageType);
    return { products: rows.length, units: rows.reduce((sum, item) => sum + item.stock, 0) };
  };
  const clinicTotals = shelfTotals('CLINIC');
  const retailTotals = shelfTotals('RETAIL');
  document.getElementById('reportUsage').textContent = `Clinic use: ${clinicTotals.products} products · ${clinicTotals.units} units | Retail use: ${retailTotals.products} products · ${retailTotals.units} units`;
  document.getElementById('reportMovements').textContent = `${rangeMovements.length} movements · ${period}`;
  const usageLine = (item) => `<span>${escapeHtml(item.name)}<small class="report-usage">${escapeHtml(usageLabels[item.usageType] || usageLabels.CLINIC)}</small></span>`;
  document.getElementById('lowStockReport').innerHTML = inventory.filter((item) => item.stockStatus === 'LOW_STOCK').map((item) => `<span class="report-line">${usageLine(item)}<b>${escapeHtml(item.stock)} left</b></span>`).join('') || '<span class="report-line">No low-stock items</span>';
  document.getElementById('expiryReport').innerHTML = inventory.filter((item) => item.stockStatus === 'NEARLY_EXPIRED' || item.stockStatus === 'EXPIRED').map((item) => `<span class="report-line">${usageLine(item)}<b>${escapeHtml(item.expiry)}</b></span>`).join('') || '<span class="report-line">No items expiring soon</span>';
}

function renderTherapists() {
  if (document.getElementById('profileRole').textContent !== 'Administrator') {
    document.getElementById('therapistCount').textContent = 'Access restricted';
    document.getElementById('therapistTable').innerHTML = '<div class="patient-empty">Administrator authorization is required to view therapist records.</div>';
    return;
  }
  document.getElementById('therapistCount').textContent = `${therapists.length} therapist record${therapists.length === 1 ? '' : 's'}`;
  document.getElementById('therapistTable').innerHTML = therapists.map((therapist) => `<div class="patient-row"><div class="patient-person"><div class="patient-avatar mint">${escapeHtml(therapist.name.split(' ').map((part) => part[0]).join('').slice(0, 2).toUpperCase())}</div><div><b>${escapeHtml(therapist.name)}</b><span>${escapeHtml(therapist.email || 'No email recorded')}</span></div></div><div class="patient-contact">${escapeHtml(therapist.phone || 'No phone recorded')}<small>ID ${escapeHtml(therapist.idNumber || 'not recorded')}</small></div><div class="patient-contact">${therapist.age != null ? `${escapeHtml(therapist.age)} years` : 'Age not recorded'}<small>Personnel record · no sign-in</small></div><span class="patient-status ${therapist.status === 'active' ? 'active' : 'archived'}">${escapeHtml(therapist.status)}</span></div>`).join('') || '<div class="patient-empty">No therapists recorded yet. Create one to assign work without creating a user account.</div>';
}

function renderUsers() {
  if (document.getElementById('profileRole').textContent !== 'Administrator') {
    document.getElementById('userCount').textContent = 'Access restricted';
    document.getElementById('userTable').innerHTML = '<div class="patient-empty">Administrator authorization is required to view users and role assignments.</div>';
    document.getElementById('activityTable').innerHTML = '<div class="patient-empty">Activity monitoring is restricted to Administrators.</div>';
    document.getElementById('roleMatrix').innerHTML = '<div class="patient-empty">Role permission details are restricted to Administrators.</div>';
    return;
  }
  const filter = document.getElementById('userRoleFilter').value;
  const rows = users.filter((user) => filter === 'all' || user.role === filter);
  document.getElementById('userCount').textContent = `${rows.length} users`;
  document.getElementById('userTable').innerHTML = rows.map((user) => `<div class="patient-row"><div class="patient-person"><div class="patient-avatar ${user.active ? 'mint' : 'peach-bg'}">${escapeHtml(user.name.split(' ').map((part) => part[0]).join('').slice(0, 2))}</div><div><b>${escapeHtml(user.name)}</b><span>${user.idNumber ? `ID ${escapeHtml(user.idNumber)} · ` : ''}${escapeHtml(user.email)}</span></div></div><div class="patient-contact">${escapeHtml(user.role)}<small>Role permissions applied</small></div><span class="patient-status ${user.active ? 'active' : 'archived'}">${user.active ? 'Active' : 'Inactive'}</span><div class="patient-actions"><button data-user="edit" data-id="${escapeHtml(user.id)}">Edit</button><button data-user="toggle" data-id="${escapeHtml(user.id)}">${user.active ? 'Deactivate' : 'Activate'}</button><button data-user="delete" data-id="${escapeHtml(user.id)}">Delete</button></div></div>`).join('') || '<div class="patient-empty">No users match this filter.</div>';
  document.getElementById('activityTable').innerHTML = auditEvents.slice(0, 12).map((event) => `<div class="movement-row"><span class="movement-type adjustment">${escapeHtml(event.module)}</span><b>${escapeHtml(activityActionLabel(event.action))}</b><span>${escapeHtml(event.user)}</span><span>${escapeHtml(event.record)}</span><time>${escapeHtml(event.time)}</time></div>`).join('') || '<div class="patient-empty">No account or permission events recorded yet.</div>';
  document.getElementById('roleMatrix').innerHTML = Object.entries(rolePermissions).map(([role, permissions]) => `<div class="role-card"><b>${escapeHtml(role)}</b><div>${permissions.map((permission) => `<span>${escapeHtml(permission)}</span>`).join('')}</div></div>`).join('');
}

function renderAudit() {
  if (document.getElementById('profileRole').textContent !== 'Administrator') {
    document.getElementById('auditCount').textContent = 'Access restricted';
    document.getElementById('auditTable').innerHTML = '<div class="patient-empty">Administrator authorization is required to view audit records.</div>';
    return;
  }
  const module = document.getElementById('auditModuleFilter').value;
  const action = document.getElementById('auditActionFilter').value;
  const rows = auditEvents.filter((event) => (module === 'all' || event.module === module) && (action === 'all' || event.action === action));
  document.getElementById('auditCount').textContent = `${rows.length} audit record${rows.length === 1 ? '' : 's'}`;
  document.getElementById('auditTable').innerHTML = rows.map((event) => `<div class="audit-row"><div><b>${escapeHtml(event.user)}</b><small>Actor</small></div><div><b>${escapeHtml(event.module)}</b><span class="audit-action ${escapeHtml(event.action.toLowerCase())}">${escapeHtml(event.action)}</span></div><div><b>${escapeHtml(event.record)}</b><small>${escapeHtml(event.reference)}</small></div><time>${escapeHtml(event.time)}</time></div>`).join('') || '<div class="patient-empty">No audit events match these filters.</div>';
}

// Printing renders a purpose-built sheet instead of the application chrome: the print stylesheet
// hides every body child except #printView, so whatever that element contains at the moment of
// printing is the whole page. Every value is escaped here because the print view is built by
// string concatenation like the list renderers, and it carries the same injection risk.
function printSheet(title, subtitle, fields, rows) {
  const view = document.getElementById('printView');
  const details = Object.entries(fields)
    .map(([label, value]) => `<div><small>${escapeHtml(label)}</small><b>${escapeHtml(value)}</b></div>`).join('');
  const columns = rows && rows.length ? Object.keys(rows[0]) : [];
  const table = columns.length
    ? `<table><thead><tr>${columns.map((column) => `<th>${escapeHtml(column)}</th>`).join('')}</tr></thead><tbody>${rows
        .map((row) => `<tr>${columns.map((column) => `<td>${escapeHtml(row[column])}</td>`).join('')}</tr>`).join('')}</tbody></table>`
    : '';
  const operator = document.getElementById('profileName')?.textContent || 'Clinic user';
  view.innerHTML = `<header><div><p class="eyebrow">Derma Clinic Philippines</p><h1>${escapeHtml(title)}</h1><p>${escapeHtml(subtitle)}</p></div><p>Printed ${escapeHtml(new Date().toLocaleString())}<br />by ${escapeHtml(operator)}</p></header><div class="detail-grid">${details}</div>${table}<footer>Derma Clinic Management System · This document was produced from the clinic's live records.</footer>`;
  window.print();
}

function downloadReport(format) {
  // The report set covers inventory, not money. Billing records belong to the external POS.
  const rows = inventory.map((item) => `${item.sku},${item.name},${item.supplier},${item.batch},${item.expiry},${item.stock},${item.unit},${item.reorder}`).join('\n');
  const content = `Product code,Product,Supplier,Batch,Expiry,Stock,Unit,Reorder threshold\n${rows}`;
  if (format === 'pdf') {
    printSheet('Inventory report', `${inventory.length} product record${inventory.length === 1 ? '' : 's'}`,
      { Products: String(inventory.length), 'Low stock': String(inventory.filter((item) => item.stockStatus === 'LOW_STOCK').length) },
      inventory.map((item) => ({ 'Product code': item.sku, Product: item.name, Supplier: item.supplier, Batch: item.batch, Expiry: item.expiry, Stock: `${item.stock} ${item.unit}` })));
    return;
  }
  const blob = new Blob([content], { type: 'text/csv;charset=utf-8' });
  const link = document.createElement('a'); link.href = URL.createObjectURL(blob); link.download = 'derma-clinic-inventory-report.csv'; link.click(); URL.revokeObjectURL(link.href);
  showToast('Excel-compatible export prepared', 'Exported values match the records displayed in Reports.');
}

function openServiceModal(service) {
  editingServiceId = service?.dbId || null;
  document.getElementById('serviceModalTitle').textContent = service ? 'Update service' : 'Create service';
  document.getElementById('serviceCode').value = service?.code || '';
  document.getElementById('serviceName').value = service?.name || '';
  document.getElementById('servicePrice').value = service?.price || '';
  document.getElementById('serviceDuration').value = service?.duration || '';
  document.getElementById('serviceError').textContent = '';
  document.getElementById('serviceProductRows').innerHTML = '';
  (service?.products || []).forEach((requirement) => addServiceProductRow(requirement));
  updateServiceProductEmpty();
  openModal('serviceModal');
}

// A service lists every product it consumes, each with its own quantity, and the link is by product
// id because that is what docket creation deducts against. Only clinic-use stock is offered: a
// retail product is sold at the front desk, not consumed by a treatment. The inventory list holds
// active products only, so a requirement on an archived product gets an option of its own; otherwise
// opening the form would quietly unselect it and saving would drop the link.
//
// Each row shows the three facts the clinic asked for: the product name, the required quantity and
// the product's measurement unit. The unit is read-only because it belongs to the product, not to the
// service, and it follows the selected product. The quantity starts at 1.
function addServiceProductRow(requirement) {
  const clinicProducts = inventory.filter((item) => item.usageType === 'CLINIC');
  const options = clinicProducts.map((item) => `<option value="${escapeHtml(item.id)}">${escapeHtml(item.name)}</option>`);
  if (requirement && !clinicProducts.some((item) => item.id === requirement.productId)) {
    options.push(`<option value="${escapeHtml(requirement.productId)}">${escapeHtml(requirement.product)}</option>`);
  }
  const row = document.createElement('div');
  row.className = 'service-product-row';
  row.innerHTML = `<label>Product name<select data-product-select required><option value="">Select a product</option>${options.join('')}</select></label>`
    + `<label>Required quantity<input data-product-quantity type="number" min="0.01" step="0.01" required value="${escapeHtml(requirement?.quantity ?? 1)}" /></label>`
    + '<label>Measurement unit<input data-product-unit type="text" readonly /></label>'
    + '<button type="button" class="secondary-button" data-remove-product>Remove</button>';
  const select = row.querySelector('[data-product-select]');
  const unitInput = row.querySelector('[data-product-unit]');
  // The unit is a property of the chosen product. A linked product that is no longer in the active
  // inventory keeps the unit the server sent with the requirement, so the row does not blank out.
  const syncUnit = () => {
    const product = inventory.find((item) => item.id === select.value);
    unitInput.value = product ? product.unit : (requirement && select.value === requirement.productId ? requirement.unit || '' : '');
  };
  select.value = requirement?.productId || '';
  select.addEventListener('change', syncUnit);
  syncUnit();
  document.getElementById('serviceProductRows').append(row);
  updateServiceProductEmpty();
}

function updateServiceProductEmpty() {
  document.getElementById('serviceProductEmpty').hidden = document.getElementById('serviceProductRows').children.length > 0;
}

// Which element holds each workspace. Defined once beside the navigation so a view name and its
// workspace cannot drift apart, and the show/hide loop below can never miss one.
const workspaceByView = {
  'Patients': 'patientsWorkspace',
  'Appointments': 'appointmentsWorkspace',
  'Consultations': 'consultationsWorkspace',
  'Treatment dockets': 'docketsWorkspace',
  'Services': 'servicesWorkspace',
  'Inventory': 'inventoryWorkspace',
  'Sales': 'salesWorkspace',
  'Reports': 'reportsWorkspace',
  'Team & access': 'teamWorkspace',
  'Audit trail': 'auditWorkspace'
};

// The single place that changes which workspace is on screen. It refuses any view the signed-in
// role is not allowed to open, and it is the only code that shows or hides a workspace, so the
// screen can never display one the role cannot use. Both the sidebar and applyRoleAccess call it.
function showView(view) {
  const role = document.getElementById('profileRole').textContent;
  if (!allowedViews(role).includes(view)) return;
  document.querySelectorAll('.nav-item.active').forEach((active) => { active.classList.remove('active'); active.removeAttribute('aria-current'); });
  const navItem = document.querySelector(`.nav-item[data-view="${view}"]`);
  if (navItem) { navItem.classList.add('active'); navItem.setAttribute('aria-current', 'page'); }
  pageLabel.textContent = view;
  document.getElementById('pageEyebrow').textContent = view === 'Patients' ? 'Patient records · Protected workspace' : formatCurrentDate();
  document.getElementById('pageTitle').innerHTML = view === 'Patients' ? 'Patient management' : `${escapeHtml(document.getElementById('profileName').textContent)} <span>✦</span>`;
  document.getElementById('pageSubtitle').textContent = view === 'Patients' ? 'Register, update, search, and securely manage clinic patient records.' : 'Here’s what’s happening across Derma Clinic Philippines today.';
  document.querySelectorAll('.dashboard-home').forEach((section) => { section.hidden = view !== 'Overview'; });
  Object.entries(workspaceByView).forEach(([name, id]) => { document.getElementById(id).hidden = name !== view; });
  if (view === 'Patients') renderPatients();
  if (view === 'Appointments') { populateClinicalPatients(); renderAppointments(); }
  if (view === 'Consultations') renderConsultations();
  if (view === 'Treatment dockets') renderDockets();
  if (view === 'Services') renderServices();
  if (view === 'Inventory') renderInventory();
  if (view === 'Sales') renderSales();
  if (view === 'Reports') renderReports();
  if (view === 'Team & access') { if (role !== 'Administrator') showToast('Authorization required', 'Only Administrators can manage users, therapists and roles.'); renderTherapists(); renderUsers(); }
  if (view === 'Audit trail') { if (role !== 'Administrator') showToast('Authorization required', 'Only Administrators can view the audit trail.'); renderAudit(); }
  sidebar.classList.remove('open');
  document.getElementById('menuToggle').setAttribute('aria-expanded', 'false');
}

document.querySelectorAll('.nav-item').forEach((item) => {
  item.addEventListener('click', () => showView(item.dataset.view));
});

document.getElementById('menuToggle').addEventListener('click', () => {
  const open = sidebar.classList.toggle('open');
  document.getElementById('menuToggle').setAttribute('aria-expanded', String(open));
});
document.getElementById('loginForm').addEventListener('submit', async (event) => {
  event.preventDefault();
  const email = document.getElementById('loginEmail').value.trim().toLowerCase();
  const password = document.getElementById('loginPassword').value;

  // Each failure is reported for what it is. One catch-all message previously blamed the
  // backend and the database account for every cause, including a frontend role-mapping
  // bug that had nothing to do with either.
  let response;
  try {
    response = await fetch(`${apiBaseUrl}/api/auth/login`, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ email, password }) });
  } catch {
    // fetch() only rejects when the request never completed: the backend is down or unreachable.
    loginError.textContent = `Cannot reach the backend at ${apiBaseUrl}. Start it, then try again.`;
    return;
  }
  if (response.status === 429) {
    // The backend throttles repeated failures. Its message carries the wait, so show that instead of
    // the bare status, and do not report the password as wrong when the attempt was never checked.
    const detail = await response.json().catch(() => null);
    loginError.textContent = detail?.message || 'Too many failed sign-in attempts. Wait a few minutes and try again.';
    return;
  }
  if (response.status === 401 || response.status === 403) {
    loginError.textContent = 'Incorrect email or password.';
    return;
  }
  if (!response.ok) {
    loginError.textContent = `Sign-in failed: the server returned ${response.status}. Check the backend log for the cause.`;
    return;
  }
  const tokenResponse = await response.json();
  const role = roleFromAccessToken(tokenResponse.accessToken);
  if (!role) {
    // The credentials were accepted but the token names a role this frontend cannot map.
    loginError.textContent = 'Signed in, but this account has a role this frontend does not recognise. Check the role name in the database.';
    return;
  }
  // Tokens are only stored once the session is known to be usable, so a rejected role
  // cannot leave a half-authenticated state behind.
  accessToken = tokenResponse.accessToken;
  refreshToken = tokenResponse.refreshToken;
  currentUserEmail = email;
  updateRole(role);
  loginError.textContent = '';
  document.getElementById('loginPassword').value = '';
  loginScreen.hidden = true;
  showToast('Signed in', `${role} workspace is ready.`);
  persistSession(role, email, tokenResponse.expiresInSeconds || sessionDurationSeconds(role));
  // The shell is revealed only after the first load settles. Revealing it earlier paints the
  // placeholder figures in index.html - a fictional appointment list, stock counts and money - for
  // as long as the API takes, so a signed-in screen could briefly show records that do not exist.
  // The wait is a single round trip, and nothing here measures layout, so building the workspace
  // while it is still hidden is safe.
  await loadPatients();
  await loadCountries();
  await loadClinicData(role);
  appShell.hidden = false;
});
document.getElementById('logoutButton').addEventListener('click', () => {
  endSession();
});
document.getElementById('patientRegisterButton').addEventListener('click', () => openPatientModal());
document.querySelector('.patient-view-tabs').addEventListener('click', async (event) => {
  const button = event.target.closest('button[data-patient-view]');
  if (!button || button.dataset.patientView === patientView) return;
  if (button.dataset.patientView === 'archived' && !archivedPatientsLoaded && !await loadArchivedPatients()) return;
  patientPage = 1;
  setPatientView(button.dataset.patientView);
  renderPatients();
});
document.querySelector('.patient-view-tabs').addEventListener('keydown', (event) => {
  const tabs = [...document.querySelectorAll('.patient-view-tab')];
  const selectedIndex = tabs.findIndex((tab) => tab.getAttribute('aria-selected') === 'true');
  const nextIndex = event.key === 'ArrowRight' ? (selectedIndex + 1) % tabs.length
    : event.key === 'ArrowLeft' ? (selectedIndex + tabs.length - 1) % tabs.length
      : event.key === 'Home' ? 0
        : event.key === 'End' ? tabs.length - 1
          : -1;
  if (nextIndex < 0) return;
  event.preventDefault();
  tabs[nextIndex].focus();
  tabs[nextIndex].click();
});
document.getElementById('modalClose').addEventListener('click', () => closeModal("modal"));
modal.addEventListener('click', (event) => { if (event.target === modal) closeModal("modal"); });
document.querySelectorAll("[data-close]").forEach((button) => button.addEventListener("click", () => closeModal(button.dataset.close)));
document.getElementById('patientForm').addEventListener('submit', async (event) => {
  event.preventDefault();
  const phoneInput = document.getElementById('patientPhoneInput');
  // The number goes to the server exactly as typed, along with the country it should be read as.
  // It is not validated here, because validating it here would mean repeating the server's rule in
  // this file -- which is what previously made every non-Philippine number fail. The server decides
  // and this form reports its answer, and the same rule therefore applies to an API client that
  // never loads this page at all.
  // skinType and allergies are sent as null rather than an empty string when they are left alone.
  // "Not assessed" is an empty option, and the server's skinType is an enum: an empty string is not
  // a value it can convert, so sending one turns a blank optional field into a 400 that names a field
  // the user never touched. null is also what the columns mean by "not recorded", which is what keeps
  // the profile's "Not assessed" and "None recorded" fallbacks working.
  const skinTypeInput = document.getElementById('patientSkinTypeInput').value;
  const allergiesInput = document.getElementById('patientAllergiesInput').value.trim();
  const request = { fullName: document.getElementById('patientNameInput').value.trim(), email: document.getElementById('patientEmailInput').value.trim(), phone: phoneInput.value.trim(), country: document.getElementById('patientCountryInput').value, dateOfBirth: document.getElementById('patientDobInput').value, skinType: skinTypeInput || null, allergies: allergiesInput || null };
  try {
    const saved = await apiRequest(editingPatientId ? `/api/patients/${editingPatientId}` : '/api/patients', { method: editingPatientId ? 'PATCH' : 'POST', body: JSON.stringify(request) });
    const patient = mapPatient(saved);
    if (editingPatientId) {
      const existingPatient = patients.find((item) => item.id === editingPatientId) || archivedPatients.find((item) => item.id === editingPatientId);
      if (existingPatient) Object.assign(existingPatient, patient);
    }
    else patients.unshift(patient);
    showToast(editingPatientId ? 'Patient updated' : 'Patient created', 'The patient record was saved to MySQL.');
  } catch (error) {
    // The server names the field and the reason -- "phone: Use a phone number with its country code,
    // ...". Replacing that with a generic message sends people to check the database connection over
    // what is a typo in one field.
    showToast('Patient not saved', saveErrorMessage(error, 'Check the backend, permissions, and MySQL connection.'));
    return;
  }
  closeModal("modal");
  event.target.reset();
  editingPatientId = null;
  renderPatients();
});
document.getElementById('patientSearch').addEventListener('input', () => { patientPage = 1; renderPatients(); });
document.getElementById('patientPagination').addEventListener('click', (event) => { const button = event.target.closest('button[data-page]'); if (!button || button.disabled) return; patientPage = Number(button.dataset.page); renderPatients(); });
document.getElementById('docketSearch').addEventListener('input', renderDockets);
document.getElementById('newDocketButton').addEventListener('click', () => {
  // A docket is raised by the front desk. The API accepts a new one only from an Administrator or
  // Receptionist, while a Dermatologist can open this workspace and read the list. Say so here
  // rather than let them fill the form and take a 403 at submit.
  if (!['Administrator', 'Receptionist'].includes(document.getElementById('profileRole').textContent)) {
    showToast('Authorization required', 'Only Administrators and Receptionists can create treatment dockets.');
    return;
  }
  populateDocketForm();
  document.getElementById('docketError').textContent = '';
  openModal('docketModal');
});
document.getElementById('addDocketService').addEventListener('click', () => addDocketLine('SERVICE'));
document.getElementById('addDocketProduct').addEventListener('click', () => addDocketLine('PRODUCT'));
document.getElementById('docketLines').addEventListener('input', updateDocketCalculation);
document.getElementById('docketLines').addEventListener('change', updateDocketCalculation);
document.getElementById('docketLines').addEventListener('click', (event) => {
  const button = event.target.closest('[data-remove-docket-line]');
  if (!button) return;
  button.closest('.docket-line-row').remove();
  updateDocketCalculation();
});
document.getElementById('appointmentForm').addEventListener('submit', async (event) => {
  event.preventDefault();
  event.stopImmediatePropagation();
  const date = document.getElementById('appointmentDate').value;
  const time = document.getElementById('appointmentTime').value;
  const patientId = document.getElementById('appointmentPatient').value;
  const staffId = document.getElementById('appointmentStaff').value;
  const therapistId = document.getElementById('appointmentTherapist').value;
  // Name the field that is actually empty. An empty patient or staff list -- no active patients, or
  // a role that loads no clinical staff -- leaves the same blank values as a half-filled form, and
  // the old wording always blamed the staff member, which sent people looking in the wrong place.
  const missing = [];
  if (!patientId) missing.push(document.getElementById('appointmentPatient').options.length ? 'a patient' : 'a patient (no active patients are available)');
  if (!date) missing.push('a date');
  if (!time) missing.push('a time');
  if (!staffId && !therapistId) missing.push('an assigned dermatologist or therapist');
  if (missing.length) {
    document.getElementById('appointmentError').textContent = `Select ${missing.join(', ').replace(/, ([^,]*)$/, ' and $1')}.`;
    return;
  }
  // The same rule the warning uses. Checking it here as well means a warning left on screen cannot
  // be bypassed by pressing the submit button, and the request never reaches the API in that case.
  const issue = appointmentSlotIssue({ date, time, staffId, therapistId, excludeDbId: editingAppointmentId });
  if (issue) {
    document.getElementById('appointmentError').textContent = issue;
    return;
  }
  const notes = document.getElementById('appointmentNotes').value.trim();
  const scheduledConsultationId = followUpConsultationId;
  const isFollowUp = Boolean(scheduledConsultationId);
  try {
    // Each assignment travels as its own id: a dermatologist is a system user, while a therapist is
    // a personnel record that never signs in.
    const requestBody = isFollowUp
      ? { consultationId: scheduledConsultationId, date, time, notes, staffId: staffId || null, therapistId: therapistId || null }
      : { patientId, date, time, notes, staffId: staffId || null, therapistId: therapistId || null };
    const requestPath = isFollowUp
      ? '/api/clinic/appointments/follow-up'
      : editingAppointmentId ? `/api/clinic/appointments/${editingAppointmentId}` : '/api/clinic/appointments';
    await apiRequest(requestPath, { method: editingAppointmentId ? 'PUT' : 'POST', body: JSON.stringify(requestBody) });
    const wasEditing = Boolean(editingAppointmentId);
    editingAppointmentId = null;
    followUpConsultationId = null;
    closeModal('appointmentModal');
    // Follow the booking to its day, so a save made while looking at another date does not appear
    // to have vanished.
    document.getElementById('appointmentBookDate').value = date;
    const role = document.getElementById('profileRole').textContent;
    await loadClinicData(role);
    renderAppointments();
    if (patientDetailPatientId) {
      const patient = patients.find((item) => item.id === patientDetailPatientId)
        || archivedPatients.find((item) => item.id === patientDetailPatientId);
      if (patient) renderPatientHistory(patient);
    }
    showToast(isFollowUp ? 'Follow-up scheduled' : wasEditing ? 'Appointment updated' : 'Appointment saved', isFollowUp ? 'The follow-up appointment was added to the daily book and linked to its consultation.' : 'The appointment was saved to MySQL.');
  } catch (error) {
    document.getElementById('appointmentError').textContent = saveErrorMessage(error, 'The appointment could not be saved.');
  }
}, true);
document.getElementById('consultationForm').addEventListener('submit', async (event) => {
  event.preventDefault();
  event.stopImmediatePropagation();
  const patientId = document.getElementById('consultationPatient').value;
  if (!patientId) {
    document.getElementById('consultationError').textContent = 'Select a patient before saving the consultation.';
    return;
  }
  const followupDate = document.getElementById('followupDateInput').value;
  const followupTime = document.getElementById('followupTimeInput').value;
  // A follow-up is an appointment on the receptionist's book, so it needs both halves. One without
  // the other is not a slot the book can display.
  if (Boolean(followupDate) !== Boolean(followupTime)) {
    document.getElementById('consultationError').textContent = 'Enter both a follow-up date and a follow-up time, or leave both blank.';
    return;
  }
  if (followupDate) {
    const issue = appointmentSlotIssue({ date: followupDate, time: followupTime, staffId: currentUserId, therapistId: '', excludeDbId: null });
    if (issue) {
      document.getElementById('consultationError').textContent = issue;
      return;
    }
  }
  try {
    await apiRequest('/api/clinic/consultations', { method: 'POST', body: JSON.stringify({ patientId, diagnosis: document.getElementById('diagnosisInput').value, recommendation: document.getElementById('recommendationInput').value, followupDate: followupDate || null, followupTime: followupTime || null }) });
    closeModal('consultationModal');
    // The follow-up appeared on the book while this modal was open; show the day it landed on.
    if (followupDate) document.getElementById('appointmentBookDate').value = followupDate;
    await loadClinicData(document.getElementById('profileRole').textContent);
    renderConsultations();
    renderAppointments();
    showToast('Consultation saved', followupDate ? `The consultation was saved and the follow-up is booked for ${followupDate} at ${timeLabel(followupTime)}.` : 'The consultation was saved to MySQL.');
  } catch (error) {
    document.getElementById('consultationError').textContent = saveErrorMessage(error, 'The consultation could not be saved.');
  }
}, true);
document.getElementById('docketForm').addEventListener('submit', async (event) => {
  event.preventDefault();
  event.stopImmediatePropagation();
  const patientId = document.getElementById('docketPatient').value;
  const clinician = {
    dermatologistId: document.getElementById('docketDermatologist').value || null,
    therapistId: document.getElementById('docketTherapist').value || null
  };
  if (!patientId) {
    document.getElementById('docketError').textContent = 'Select a patient before creating the docket.';
    return;
  }
  const docket = docketLineData();
  if (!docket.items.length) docket.errors.push('Add at least one item to the docket.');
  if (docket.errors.length) {
    document.getElementById('docketError').textContent = [...new Set(docket.errors)].join(' ');
    return;
  }
  try {
    const created = await apiRequest('/api/clinic/dockets', { method: 'POST', body: JSON.stringify({ patientId, appointmentId: null, items: docket.items, ...clinician }) });
    closeModal('docketModal');
    await loadClinicData(document.getElementById('profileRole').textContent);
    renderDockets();
    showToast('Docket saved', 'The itemized treatment docket was saved and all required stock was deducted.');
    // Every new docket comes with its POS handoff code. Opening it now means the code is generated
    // as part of creating the docket, not discovered later from the list.
    const newDocket = dockets.find((docket) => docket.id === created?.docketNumber);
    if (newDocket) openDocketQrModal(newDocket);
  } catch (error) {
    document.getElementById('docketError').textContent = saveErrorMessage(error, 'The docket could not be saved.');
  }
}, true);
document.getElementById('serviceForm').addEventListener('submit', async (event) => {
  event.preventDefault();
  event.stopImmediatePropagation();
  const code = document.getElementById('serviceCode').value.trim();
  const name = document.getElementById('serviceName').value.trim();
  const price = Number(document.getElementById('servicePrice').value);
  const duration = Number(document.getElementById('serviceDuration').value);
  if (!code || !name || !Number.isFinite(price) || price < 0 || !Number.isInteger(duration) || duration <= 0) {
    document.getElementById('serviceError').textContent = 'Enter a code, name, non-negative price, and positive whole-number duration.';
    return;
  }
  // The product rows are checked before anything is sent. Found after the service was created, a bad
  // row would leave it saved without its products.
  const products = [...document.querySelectorAll('#serviceProductRows .service-product-row')].map((row) => ({
    productId: row.querySelector('[data-product-select]').value,
    quantity: Number(row.querySelector('[data-product-quantity]').value)
  }));
  if (products.some((requirement) => !requirement.productId || !Number.isFinite(requirement.quantity) || requirement.quantity <= 0)) {
    document.getElementById('serviceError').textContent = 'Select a product and a quantity greater than zero for every required product.';
    return;
  }
  if (new Set(products.map((requirement) => requirement.productId)).size !== products.length) {
    document.getElementById('serviceError').textContent = 'A product can only be required once per service.';
    return;
  }
  const details = JSON.stringify({ code, name, price, duration });
  const updating = Boolean(editingServiceId);
  try {
    if (updating) {
      await apiRequest(`/api/clinic/services/${editingServiceId}`, { method: 'PUT', body: details });
    } else {
      const saved = await apiRequest('/api/clinic/services', { method: 'POST', body: details });
      // From here on the form is editing the service it just created, so if linking its products
      // fails, saving again updates that service instead of colliding with its own code.
      editingServiceId = saved?.id ? String(saved.id) : null;
    }
    // The products a service consumes are what let docket creation deduct stock. The list replaces
    // whatever was linked before, so an edit always sends it: an empty list is how links are cleared.
    if (editingServiceId && (updating || products.length)) {
      await apiRequest(`/api/clinic/services/${editingServiceId}/product`, { method: 'PUT', body: JSON.stringify({ products }) });
    }
    closeModal('serviceModal');
    await loadClinicData(document.getElementById('profileRole').textContent);
    renderServices();
    showToast(updating ? 'Service updated' : 'Service saved', updating ? 'The changes were saved to MySQL.' : 'The service was saved to MySQL.');
  } catch (error) {
    document.getElementById('serviceError').textContent = saveErrorMessage(error, 'The service could not be saved.');
  }
}, true);
document.getElementById('movementForm').addEventListener('submit', async (event) => {
  event.preventDefault();
  event.stopImmediatePropagation();
  const type = document.getElementById('movementType').value === 'out' ? 'STOCK_OUT' : 'STOCK_IN';
  const productId = document.getElementById('movementProduct').value;
  const quantity = Number(document.getElementById('movementQuantity').value);
  const errorBox = document.getElementById('movementError');
  if (!productId || !Number.isFinite(quantity) || quantity <= 0) {
    errorBox.textContent = 'Select a product and enter a quantity greater than zero.';
    return;
  }
  const item = inventory.find((entry) => entry.id === productId);
  // Check the shelf before sending: the server refuses this anyway, but the message can name the
  // product and what is actually available instead of a bare 400.
  if (type === 'STOCK_OUT' && item && quantity > item.stock) {
    errorBox.textContent = `${item.name} has ${item.stock} ${item.unit} available. A Stock Out cannot take more than that.`;
    return;
  }
  const expiry = document.getElementById('movementExpiry').value;
  if (type === 'STOCK_IN' && !expiry) {
    errorBox.textContent = 'Enter the expiry date of the delivered stock.';
    return;
  }
  try {
    await apiRequest('/api/clinic/movements', { method: 'POST', body: JSON.stringify({ productId, type, quantity, ...(type === 'STOCK_IN' ? { expiry } : {}) }) });
    closeModal('movementModal');
    await loadClinicData(document.getElementById('profileRole').textContent);
    renderInventory();
    showToast('Inventory saved', `The ${type === 'STOCK_IN' ? 'Stock In' : 'Stock Out'} was saved and the product quantity updated.`);
  } catch (failure) {
    errorBox.textContent = saveErrorMessage(failure, 'The inventory movement could not be saved.');
  }
}, true);
document.getElementById('docketTable').addEventListener('click', async (event) => {
  const button = event.target.closest('button');
  if (!button) return;
  const docket = dockets.find((item) => item.id === button.dataset.id);
  if (!docket) return;
  if (button.dataset.docket === 'preview') {
    document.getElementById('docketDetailPatient').textContent = docket.patient;
    const fields = docketDetailFields(docket);
    document.getElementById('docketDetailGrid').innerHTML = Object.entries(fields)
      .map(([label, value]) => `<div><small>${escapeHtml(label)}</small><b>${escapeHtml(value)}</b></div>`).join('');
    document.getElementById('docketDetailItems').innerHTML = docket.items.map((item) => {
      const quantity = item.type === 'PRODUCT' ? `${item.quantity} ${item.productUnit}` : '1';
      const amount = item.lineTotal == null ? 'Price not recorded' : `₱${item.lineTotal.toFixed(2)}`;
      const unitPrice = item.unitPrice == null ? 'Unit price not recorded' : `₱${item.unitPrice.toFixed(2)} each`;
      return `<div class="docket-detail-line"><div><b>${escapeHtml(item.name)}</b><small>${escapeHtml(item.type === 'PRODUCT' ? 'Retail product' : 'Treatment service')} · Qty ${escapeHtml(quantity)} · ${escapeHtml(unitPrice)}</small></div><b>${escapeHtml(amount)}</b></div>`;
    }).join('') || '<p class="patient-empty">No docket items recorded.</p>';
    openModal('docketDetailModal');
  }
  if (button.dataset.docket === 'print') {
    const rows = docket.items.map((item) => ({
      Item: item.name,
      Type: item.type === 'PRODUCT' ? 'Retail product' : 'Treatment service',
      Quantity: item.type === 'PRODUCT' ? `${item.quantity} ${item.productUnit}` : '1',
      'Unit price': item.unitPrice == null ? 'Not recorded' : `₱${item.unitPrice.toFixed(2)}`,
      Amount: item.lineTotal == null ? 'Not recorded' : `₱${item.lineTotal.toFixed(2)}`
    }));
    printSheet('Treatment docket', docket.id, docketDetailFields(docket), rows);
  }
  // The docket QR is the handoff to the external POS: it carries the treatment details the POS
  // needs to raise the sale there. It is not a patient record code and contains no billing state.
  if (button.dataset.docket === 'qr') openDocketQrModal(docket);
});
document.getElementById('newServiceButton').addEventListener('click', () => openServiceModal());
document.getElementById('addServiceProductButton').addEventListener('click', () => addServiceProductRow());
document.getElementById('serviceProductRows').addEventListener('click', (event) => {
  const button = event.target.closest('[data-remove-product]');
  if (!button) return;
  button.closest('.service-product-row').remove();
  updateServiceProductEmpty();
});
document.getElementById('serviceStatusFilter').addEventListener('change', renderServices);
document.getElementById('serviceTable').addEventListener('click', async (event) => {
  const button = event.target.closest('button');
  if (!button) return;
  const service = services.find((item) => item.id === button.dataset.id);
  if (!service) return;
  if (button.dataset.service === 'edit') openServiceModal(service);
  if (button.dataset.service === 'archive') {
    const nextStatus = service.status === 'active' ? 'archived' : 'active';
    try {
      await apiRequest(`/api/clinic/services/${service.dbId}/${nextStatus === 'archived' ? 'archive' : 'restore'}`, { method: 'PATCH' });
      service.status = nextStatus;
      renderServices();
      showToast(nextStatus === 'active' ? 'Service restored' : 'Service archived', 'The service status was saved to MySQL.');
    } catch (error) {
      showToast('Service not updated', saveErrorMessage(error, 'The service status could not be changed.'));
    }
  }
});
document.getElementById('inventorySearch').addEventListener('input', renderInventory);
document.getElementById('inventoryFilter').addEventListener('change', renderInventory);
document.getElementById('supplierButton').addEventListener('click', async () => {
  try { await loadSuppliers(); } catch (error) { showToast('Suppliers unavailable', saveErrorMessage(error, 'The supplier list could not be loaded.')); }
  renderSuppliers();
  openModal('supplierModal');
});
document.getElementById('supplierForm').addEventListener('submit', async (event) => {
  event.preventDefault();
  const name = document.getElementById('supplierName').value.trim();
  const email = document.getElementById('supplierEmail').value.trim();
  if (!name || !email) { showToast('Supplier not saved', 'A supplier name and contact email are required.'); return; }
  try {
    await apiRequest('/api/clinic/suppliers', { method: 'POST', body: JSON.stringify({ name, email }) });
    event.target.reset();
    await loadSuppliers();
    renderSuppliers();
    showToast('Supplier saved', 'The supplier record was saved to MySQL.');
  } catch (error) {
    showToast('Supplier not saved', saveErrorMessage(error, 'The supplier could not be saved.'));
  }
});
document.getElementById('stockMovementButton').addEventListener('click', () => { populateMovementForm(); document.getElementById('movementError').textContent = ''; openModal('movementModal'); });
document.getElementById('inventoryUsageTabs').addEventListener('click', (event) => {
  const button = event.target.closest('button[data-usage]');
  if (!button) return;
  inventoryUsage = button.dataset.usage;
  document.querySelectorAll('#inventoryUsageTabs button').forEach((tab) => {
    const selected = tab === button;
    tab.classList.toggle('active', selected);
    tab.setAttribute('aria-selected', String(selected));
  });
  renderInventory();
});
['inventoryTable', 'stockAlertsTable', 'supplierList'].forEach((id) => document.getElementById(id).addEventListener('click', handleInventoryRecordClick));
document.getElementById('productViewModal').addEventListener('click', async (event) => {
  const button = event.target.closest('button[data-product-action]');
  if (!button) return;
  const item = inventory.find((record) => record.id === viewingProductId);
  if (!item) return;
  if (button.dataset.productAction === 'history') { closeModal('productViewModal'); openInventoryHistory(item); }
  if (button.dataset.productAction === 'move') { closeModal('productViewModal'); populateMovementForm(item.id); document.getElementById('movementError').textContent = ''; openModal('movementModal'); }
  if (button.dataset.productAction === 'archive') { closeModal('productViewModal'); await archiveInventoryProduct(item); }
});
document.getElementById('archivedProductsButton').addEventListener('click', async () => {
  if (document.getElementById('profileRole').textContent !== 'Administrator') {
    showToast('Authorization required', 'Only an Administrator can view archived products.');
    return;
  }
  const list = document.getElementById('archivedProductsList');
  list.innerHTML = '<div class="patient-empty">Loading archived products…</div>';
  openModal('archivedProductsModal');
  try {
    renderArchivedProducts(await loadArchivedProducts());
  } catch (error) {
    list.innerHTML = '<div class="patient-empty">Archived products could not be loaded.</div>';
    showToast('Archived products unavailable', saveErrorMessage(error, 'The archived product list could not be loaded.'));
  }
});
document.getElementById('archivedProductsList').addEventListener('click', async (event) => {
  const button = event.target.closest('button');
  if (!button || button.dataset.archived !== 'restore') return;
  if (document.getElementById('profileRole').textContent !== 'Administrator') {
    showToast('Authorization required', 'Only an Administrator can restore a product.');
    return;
  }
  try {
    await apiRequest(`/api/clinic/products/${encodeURIComponent(button.dataset.id)}/restore`, { method: 'PATCH' });
    renderArchivedProducts(await loadArchivedProducts());
    await loadClinicData(document.getElementById('profileRole').textContent);
    renderInventory();
    renderSuppliers();
    showToast('Product restored', 'The product is back in the active inventory catalogue.');
  } catch (error) {
    showToast('Product not restored', saveErrorMessage(error, 'The product could not be restored.'));
  }
});
document.getElementById('salesDateFrom').addEventListener('change', renderSales);
document.getElementById('salesDateTo').addEventListener('change', renderSales);
document.getElementById('salesClearDates').addEventListener('click', () => {
  document.getElementById('salesDateFrom').value = '';
  document.getElementById('salesDateTo').value = '';
  renderSales();
});
document.getElementById('reportDateFilter').addEventListener('change', renderReports);
document.getElementById('exportPdfButton').addEventListener('click', () => downloadReport('pdf'));
document.getElementById('exportExcelButton').addEventListener('click', () => downloadReport('excel'));
document.getElementById('newTherapistButton').addEventListener('click', () => {
  if (document.getElementById('profileRole').textContent !== 'Administrator') {
    showToast('Authorization required', 'Only Administrators can create therapist records.');
    return;
  }
  document.getElementById('therapistForm').reset();
  document.getElementById('therapistError').textContent = '';
  openModal('therapistModal');
});
document.getElementById('therapistForm').addEventListener('submit', async (event) => {
  event.preventDefault();
  if (document.getElementById('profileRole').textContent !== 'Administrator') return;
  const fullName = document.getElementById('therapistNameInput').value.trim();
  const email = document.getElementById('therapistEmailInput').value.trim();
  const phone = document.getElementById('therapistPhoneInput').value.trim();
  const age = Number(document.getElementById('therapistAgeInput').value);
  const idNumber = document.getElementById('therapistIdNumberInput').value.trim();
  const error = document.getElementById('therapistError');
  if (!fullName || !email || !phone || !idNumber || !Number.isInteger(age) || age < 18 || age > 120) {
    error.textContent = 'Enter a name, email, phone number, ID number, and an age between 18 and 120.';
    return;
  }
  try {
    await apiRequest('/api/therapists', { method: 'POST', body: JSON.stringify({ fullName, email, phone, age, idNumber }) });
    closeModal('therapistModal');
    await loadClinicData('Administrator');
    renderTherapists();
    showToast('Therapist saved', 'The therapist can now be assigned to appointments and treatment dockets.');
  } catch (requestError) {
    error.textContent = saveErrorMessage(requestError, 'The therapist record could not be saved.');
  }
});
document.getElementById('userRoleFilter').addEventListener('change', renderUsers);
document.getElementById('newUserButton').addEventListener('click', () => { if (document.getElementById('profileRole').textContent !== 'Administrator') { showToast('Authorization required', 'Only Administrators can create users.'); return; } editingUserId = null; document.getElementById('userModalTitle').textContent = 'Create user'; document.getElementById('userForm').reset(); document.getElementById('userPasswordFields').hidden = false; document.getElementById('userPassword').required = true; document.getElementById('userConfirmPassword').required = true; document.getElementById('userIdNumber').required = true; openModal('userModal'); });
document.getElementById('userForm').addEventListener('submit', async (event) => {
  event.preventDefault();
  event.stopImmediatePropagation();
  if (document.getElementById('profileRole').textContent !== 'Administrator') return;
  const error = document.getElementById('userError');
  try {
    const request = {
      fullName: document.getElementById('userName').value.trim(),
      email: document.getElementById('userEmail').value.trim(),
      idNumber: document.getElementById('userIdNumber').value.trim(),
      password: document.getElementById('userPassword').value,
      role: document.getElementById('userRole').value
    };
    if (!request.fullName || !request.email || !request.idNumber || (!editingUserId && !request.password) || !request.role) {
      error.textContent = 'Full name, email, ID number, password, and role are required.';
      return;
    }
    if (!editingUserId && request.password !== document.getElementById('userConfirmPassword').value) {
      error.textContent = 'The password and confirmation do not match.';
      return;
    }
    if (editingUserId) {
      await apiRequest(`/api/users/${editingUserId}`, { method: 'PUT', body: JSON.stringify({ fullName: request.fullName, email: request.email, idNumber: request.idNumber, role: request.role }) });
    } else {
      await apiRequest('/api/users', { method: 'POST', body: JSON.stringify({ fullName: request.fullName, email: request.email, idNumber: request.idNumber, password: request.password, role: request.role }) });
    }
    closeModal('userModal');
    await loadClinicData('Administrator');
    renderUsers();
    showToast('User saved', 'The team member was saved to MySQL.');
  } catch (requestError) {
    error.textContent = saveErrorMessage(requestError, 'The team member could not be saved.');
  }
}, true);
document.getElementById('userTable').addEventListener('click', async (event) => { const button = event.target.closest('button'); if (!button) return; if (document.getElementById('profileRole').textContent !== 'Administrator') { showToast('Authorization required', 'Only Administrators can manage users.'); return; } const user = users.find((item) => item.id === button.dataset.id); if (button.dataset.user === 'toggle') { if (!user) return; if (!/^\d+$/.test(user.id)) { showToast('Not updated', 'This row only exists in the browser, so there is no database account to update.'); return; } const nextActive = !user.active; apiRequest(`/api/users/${user.id}/status`, { method: 'PATCH', body: JSON.stringify({ active: nextActive }) }).then(async () => { user.active = nextActive; await loadAuditEvents().catch(() => {}); renderUsers(); showToast(nextActive ? 'User activated' : 'User deactivated', 'The account status was saved to MySQL.'); }).catch((error) => showToast('User not updated', saveErrorMessage(error, 'Check your backend permissions and database connection.'))); } if (button.dataset.user === 'edit') { editingUserId = user.id; document.getElementById('userModalTitle').textContent = 'Update user'; document.getElementById('userName').value = user.name; document.getElementById('userEmail').value = user.email; document.getElementById('userIdNumber').value = user.idNumber || ''; document.getElementById('userRole').value = user.role; document.getElementById('userPassword').value = ''; document.getElementById('userConfirmPassword').value = ''; document.getElementById('userPassword').required = false; document.getElementById('userConfirmPassword').required = false; document.getElementById('userPasswordFields').hidden = true; openModal('userModal'); } if (button.dataset.user === 'delete') { if (!user) return; if (!/^\d+$/.test(user.id)) { showToast('Not deleted', 'This row only exists in the browser, so there is no database account to delete.'); return; } if (String(user.email).toLowerCase() === String(currentUserEmail || '').toLowerCase()) { showToast('Not deleted', 'You cannot delete the account you are signed in with.'); return; } if (!await confirmAction({ title: 'Delete this user?', message: `Are you sure you want to delete ${user.name} (${user.email})? They lose access immediately and can no longer sign in. This action is recorded in the audit trail.`, confirmLabel: 'Yes, delete user' })) return; apiRequest(`/api/users/${user.id}/delete`, { method: 'PATCH' }).then(async () => { users.splice(users.findIndex((item) => item.id === user.id), 1); await loadAuditEvents().catch(() => {}); renderUsers(); showToast('User deleted', 'The account was deleted in MySQL and can no longer sign in.'); }).catch((error) => showToast('User not deleted', saveErrorMessage(error, 'Check your backend permissions and database connection.'))); } });
document.getElementById('auditModuleFilter').addEventListener('change', renderAudit);
document.getElementById('auditActionFilter').addEventListener('change', renderAudit);
document.getElementById('appointmentSearch').addEventListener('input', renderAppointments);
document.getElementById('appointmentFilter').addEventListener('change', renderAppointments);
document.getElementById('appointmentBookDate').addEventListener('change', renderAppointments);
document.getElementById('appointmentPreviousDay').addEventListener('click', () => shiftBookDate(-1));
document.getElementById('appointmentNextDay').addEventListener('click', () => shiftBookDate(1));
// The slot warning follows every field that can make a slot unavailable, not only the time.
['appointmentDate', 'appointmentTime', 'appointmentStaff', 'appointmentTherapist'].forEach((id) => {
  document.getElementById(id).addEventListener('change', updateAppointmentWarning);
});
['followupDateInput', 'followupTimeInput'].forEach((id) => {
  document.getElementById(id).addEventListener('change', updateConsultationWarning);
});
document.getElementById('newAppointmentButton').addEventListener('click', () => openAppointmentModal());

function shiftBookDate(days) {
  const input = document.getElementById('appointmentBookDate');
  const current = input.value ? new Date(`${input.value}T00:00:00`) : new Date();
  current.setDate(current.getDate() + days);
  input.value = localDateKey(current);
  renderAppointments();
}
document.getElementById('appointmentTable').addEventListener('click', async (event) => {
  const button = event.target.closest('button');
  if (!button) return;
  const appointment = appointments.find((item) => item.id === button.dataset.id);
  if (!appointment) return;
  if (button.dataset.appointment === 'view') {
    document.getElementById('appointmentDetailPatient').textContent = appointment.patient;
    document.getElementById('appointmentDetailId').textContent = appointment.id;
    document.getElementById('appointmentDetailStatus').textContent = appointment.status;
    document.getElementById('appointmentDetailSchedule').textContent = `${appointment.date} at ${appointment.time}`;
    document.getElementById('appointmentDetailStaff').textContent = appointment.staff;
    document.getElementById('appointmentDetailPhone').textContent = appointment.phoneDisplay || 'No phone recorded';
    document.getElementById('appointmentDetailNotes').textContent = appointment.notes || 'No notes';
    document.getElementById('appointmentDetailPatientRef').textContent = appointment.patientNumber || '—';
    const docket = dockets.find((item) => item.appointmentId === appointment.dbId);
    document.getElementById('appointmentDetailDocket').textContent = docket ? `${docket.id} · ${docket.itemSummary}${docket.total == null ? '' : ` · ₱${docket.total.toFixed(2)}`}` : 'No docket raised';
    openModal('appointmentDetailModal');
  }
  if (button.dataset.appointment === 'update') openAppointmentModal(appointment);
  if (button.dataset.appointment === 'cancel') {
    if (['completed', 'cancelled'].includes(appointment.status)) return;
    if (!await confirmAction({
      title: `Cancel appointment ${appointment.id}?`,
      message: `Cancel ${appointment.id} for ${appointment.patient}? The appointment will remain in the schedule history as cancelled, and its time slot will become available.`,
      confirmLabel: 'Yes, cancel appointment'
    })) return;
    try {
      await apiRequest(`/api/clinic/appointments/${appointment.dbId}/status`, { method: 'PATCH', body: JSON.stringify({ status: 'CANCELLED' }) });
      appointment.status = 'cancelled';
      renderAppointments();
      showToast('Appointment cancelled', 'The appointment remains in the schedule history and its status was saved to MySQL.');
    } catch (error) {
      showToast('Appointment not cancelled', saveErrorMessage(error, 'The appointment could not be cancelled.'));
    }
  }
  if (button.dataset.appointment === 'complete') {
    if (['completed', 'cancelled'].includes(appointment.status)) return;
    if (!await confirmAction({ title: 'Mark this appointment complete?', message: `Record ${appointment.id} (${appointment.patient}) as completed? The change is saved to the appointment record and written to the audit trail.`, confirmLabel: 'Yes, mark complete' })) return;
    try {
      await apiRequest(`/api/clinic/appointments/${appointment.dbId}/status`, { method: 'PATCH', body: JSON.stringify({ status: 'COMPLETED' }) });
      appointment.status = 'completed';
      renderAppointments();
      showToast('Appointment updated', 'The status change was saved to MySQL.');
    } catch (error) {
      showToast('Appointment not updated', saveErrorMessage(error, 'The status could not be changed.'));
    }
  }
});
document.getElementById('newConsultationButton').addEventListener('click', () => {
  if (!['Administrator', 'Dermatologist'].includes(document.getElementById('profileRole').textContent)) {
    showToast('Authorization required', 'Only clinical roles can create consultations.');
    return;
  }
  document.getElementById('consultationForm').reset();
  // The form no longer asks for clinical notes or free-text follow-up instructions; the recall is
  // scheduled with a date and time instead.
  populateClinicalPatients();
  document.getElementById('consultationWarning').hidden = true;
  document.getElementById('consultationError').textContent = '';
  openModal('consultationModal');
});
document.getElementById('patientHistoryBody').addEventListener('click', (event) => {
  const button = event.target.closest('button[data-follow-up-consultation]');
  if (!button) return;
  const consultation = consultations.find((item) => item.dbId === button.dataset.followUpConsultation);
  if (consultation) scheduleConsultationFollowUp(consultation);
});
document.getElementById('patientTable').addEventListener('click', async (event) => {
  const button = event.target.closest('button');
  if (!button) return;
  const patientList = patientView === 'archived' ? archivedPatients : patients;
  const patient = patientList.find((item) => item.id === button.dataset.id);
  if (!patient) return;
  if (button.dataset.action === 'edit') openPatientModal(patient);
  if (button.dataset.action === 'view') openPatientDetail(patient);
  if (button.dataset.action === 'archive') {
    const nextStatus = patientView === 'active' ? 'archived' : 'active';
    if (!await confirmAction({
      title: `${nextStatus === 'archived' ? 'Archive' : 'Restore'} ${patient.name}?`,
      message: nextStatus === 'archived'
        ? 'The patient is hidden from active lists. Nothing is deleted, and the record can be restored later.'
        : 'The patient returns to the active list with their history intact.',
      confirmLabel: nextStatus === 'archived' ? 'Yes, archive' : 'Yes, restore'
    })) return;
    try {
      await apiRequest(`/api/patients/${patient.id}/${nextStatus === 'archived' ? 'archive' : 'restore'}`, { method: 'PATCH' });
      patient.status = nextStatus;
      patientList.splice(patientList.indexOf(patient), 1);
      if (nextStatus === 'active') {
        patients.unshift(patient);
      } else if (archivedPatientsLoaded) {
        archivedPatients.unshift(patient);
      }
      renderPatients();
      showToast(patient.status === 'active' ? 'Patient restored' : 'Patient archived', 'The status change was saved to MySQL.');
    } catch (error) {
      showToast('Patient not updated', saveErrorMessage(error, 'Check your backend permissions and database connection.'));
    }
  }
});
document.querySelectorAll('.more-button[data-goto]').forEach((button) => {
  button.addEventListener('click', () => {
    const target = [...document.querySelectorAll('.nav-item')].find((item) => item.dataset.view === button.dataset.goto);
    // A panel's "•••" opens the workspace that holds the full list. Roles that cannot see that
    // workspace get an explanation rather than a button that silently does nothing.
    if (!target || target.hidden) { showToast('Workspace unavailable', `Your role does not include ${button.dataset.goto}.`); return; }
    target.click();
  });
});
// Buttons that name a workspace navigate to it instead of toasting that it exists.
const workspaceShortcuts = {
  'View calendar': 'Appointments',
  'View all appointments': 'Appointments',
  'View audit trail': 'Audit trail',
  'Manage inventory': 'Inventory'
};
document.querySelectorAll('.full-width-button, .text-button').forEach((button) => {
  button.addEventListener('click', () => {
    const target = workspaceShortcuts[button.textContent.replace(/[→\s]+$/, '').trim()];
    const navItem = target && document.querySelector(`.nav-item[data-view="${target}"]`);
    if (!navItem || navItem.hidden) { showToast('Workspace unavailable', 'Your role does not include this workspace.'); return; }
    navItem.click();
  });
});
document.getElementById('notificationsButton').addEventListener('click', () => {
  const lowStock = inventory.filter((item) => item.stockStatus === 'LOW_STOCK');
  const expiring = inventory.filter((item) => item.stockStatus === 'NEARLY_EXPIRED' || item.stockStatus === 'EXPIRED');
  if (!lowStock.length && !expiring.length) { showToast('Nothing needs attention', 'No products are low on stock or expiring within 30 days.'); return; }
  const navItem = document.querySelector('.nav-item[data-view="Inventory"]');
  if (navItem && !navItem.hidden) navItem.click();
  showToast(`${lowStock.length + expiring.length} inventory alert${lowStock.length + expiring.length === 1 ? '' : 's'}`, `${lowStock.length} low on stock · ${expiring.length} expired or expiring within 30 days.`);
});
// The application is served by the backend at http://localhost:8080 so the page shares an origin
// with the API. A page opened as a local file (file://) sends Origin: null and can never reach the
// API. This used to fall back to fictional in-memory data, which made a working system show the
// wrong records. Refuse to start instead of pretending.
if (window.location.protocol === 'file:') {
  loginScreen.hidden = false;
  appShell.hidden = true;
  loginError.textContent = 'Open this application at http://localhost:8080 with the backend running. Opening index.html directly cannot reach the API.';
} else {
  restoreSession();
}
