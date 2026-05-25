export default function Footer() {
  return (
    <footer className="mt-10">
      <div className="bg-[#5ca2ea] py-2 text-center text-[11px] font-semibold uppercase tracking-wide text-white">
        Syntec Group supplier of premium scientific and clinical instruments, products and services
      </div>
      <div className="border-t border-slate-200 bg-[#c8ddf1]">
        <div className="mx-auto grid max-w-[1240px] gap-8 px-4 py-10 md:grid-cols-4">
          <div>
            <img src="/assets/images/Syntec_Group_Logo_Small.png" alt="Syntec" className="h-11 w-auto" />
            <p className="mt-3 text-sm text-slate-700">Supplier of premium scientific and clinical instruments.</p>
          </div>
          <div>
            <h3 className="text-sm font-semibold uppercase text-[var(--syntec-navy)]">Quick Links</h3>
            <ul className="mt-3 space-y-2 text-sm text-slate-700">
              <li>Home Page</li>
              <li>About Us</li>
              <li>Contact Us</li>
            </ul>
          </div>
          <div>
            <h3 className="text-sm font-semibold uppercase text-[var(--syntec-navy)]">Divisions</h3>
            <ul className="mt-3 space-y-3 text-sm text-slate-700">
              <li>Syntec Scientific</li>
              <li>Syntec International</li>
              <li>Sys Laboratories</li>
            </ul>
          </div>
          <div>
            <h3 className="text-sm font-semibold uppercase text-[var(--syntec-navy)]">Contact Us</h3>
            <ul className="mt-3 space-y-2 text-sm text-slate-700">
              <li>Unit 61 Northwest Logistics Park, Dublin 15</li>
              <li>Info@syntec.ie</li>
              <li>+353 1 8612100</li>
              <li>+353 1 8612101</li>
            </ul>
          </div>
        </div>
      </div>
      <div className="bg-[#13181f] py-2 text-center text-[9px] uppercase tracking-wide text-white">
        Copyright 2026 Syntec Group
      </div>
    </footer>
  );
}
