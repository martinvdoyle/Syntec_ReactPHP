export default function SaveSuccessDialog({ open, onClose, message = "Saved successfully" }) {
  if (!open) return null;
  return (
    <div className="fixed inset-0 z-[1000] flex items-center justify-center bg-slate-900/35 p-4">
      <div className="w-full max-w-sm rounded-2xl border border-emerald-200 bg-white p-5 shadow-2xl">
        <div className="mb-2 text-lg font-black text-emerald-700">Success</div>
        <p className="mb-4 text-sm font-medium text-slate-700">{message}</p>
        <div className="flex justify-end">
          <button
            type="button"
            onClick={onClose}
            className="rounded-lg bg-emerald-600 px-4 py-2 text-sm font-semibold text-white transition hover:bg-emerald-700"
          >
            OK
          </button>
        </div>
      </div>
    </div>
  );
}

