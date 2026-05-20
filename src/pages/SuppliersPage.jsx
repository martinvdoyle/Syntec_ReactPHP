import { useEffect, useState } from "react";
import { fetchSuppliers } from "../api/suppliers";
import { fallbackMissingImage } from "../utils/assets";

function SupplierCard({ supplier }) {
  const [logoSrc, setLogoSrc] = useState(supplier.logoPath || fallbackMissingImage);

  return (
    <article className="rounded-xl border border-slate-200 bg-white p-5 shadow-sm">
      <img
        src={logoSrc}
        alt={supplier.name}
        className="h-14 w-auto object-contain"
        onError={() => setLogoSrc(fallbackMissingImage)}
      />
      <h2 className="mt-4 text-lg font-semibold text-[var(--syntec-navy)]">{supplier.name}</h2>
      <p className="mt-2 text-sm text-slate-600">{supplier.shortDescription || "Supplier information will be expanded in next phase."}</p>
      <div className="mt-4 flex items-center justify-between">
        <span className="rounded-full bg-slate-100 px-2 py-1 text-xs font-medium text-slate-700">{supplier.businessUnit || "General"}</span>
        {supplier.websiteUrl ? (
          <a
            href={supplier.websiteUrl}
            target="_blank"
            rel="noreferrer"
            className="text-sm font-semibold text-[var(--syntec-blue)]"
          >
            Visit
          </a>
        ) : null}
      </div>
    </article>
  );
}

export default function SuppliersPage() {
  const [suppliers, setSuppliers] = useState([]);

  useEffect(() => {
    let mounted = true;
    fetchSuppliers().then((rows) => {
      if (mounted) {
        setSuppliers(rows);
      }
    });

    return () => {
      mounted = false;
    };
  }, []);

  return (
    <section className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold text-[var(--syntec-navy)]">Suppliers</h1>
        <p className="mt-2 text-slate-700">Database-driven supplier listing connected to `/api/suppliers.php`.</p>
      </div>

      <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
        {suppliers.map((supplier) => (
          <SupplierCard key={supplier.id} supplier={supplier} />
        ))}
      </div>
    </section>
  );
}
