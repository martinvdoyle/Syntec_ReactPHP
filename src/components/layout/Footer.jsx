export default function Footer() {
  return (
    <footer className="mt-10 border-t border-slate-200 bg-white">
      <div className="mx-auto grid max-w-7xl gap-8 px-4 py-10 md:grid-cols-3">
        <div>
          <img src="/assets/images/Syntec_Group_Logo_Small.png" alt="Syntec" className="h-10 w-auto" />
          <p className="mt-3 text-sm text-slate-600">Diagnostics, Pharma, and Surgery solutions.</p>
        </div>
        <div>
          <h3 className="text-sm font-semibold text-[var(--syntec-navy)]">Company</h3>
          <ul className="mt-3 space-y-2 text-sm text-slate-600">
            <li>About</li>
            <li>Contact</li>
            <li>Privacy</li>
          </ul>
        </div>
        <div>
          <h3 className="text-sm font-semibold text-[var(--syntec-navy)]">Suppliers</h3>
          <ul className="mt-3 space-y-2 text-sm text-slate-600">
            <li>Scientific</li>
            <li>International</li>
            <li>SysLabs</li>
          </ul>
        </div>
      </div>
    </footer>
  );
}
