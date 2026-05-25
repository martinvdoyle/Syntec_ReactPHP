export default function HomePage() {
  return (
    <section className="space-y-0">
      <section
        className="relative min-h-[520px] overflow-hidden rounded-sm border border-slate-300 bg-slate-900"
        style={{
          backgroundImage: "linear-gradient(rgba(22,28,36,.55), rgba(22,28,36,.55)), url('/assets/images/sliders/Home/Home_2.jpg')",
          backgroundSize: "cover",
          backgroundPosition: "center",
        }}
      >
        <div className="mx-auto flex min-h-[520px] max-w-[1240px] flex-col items-center justify-center px-4 text-center text-white">
          <h1 className="text-5xl font-black tracking-tight md:text-6xl">
            Syntec <span className="text-[#5ca2ea]">Scientific</span>
          </h1>
          <p className="mt-8 max-w-[760px] text-4xl font-extrabold leading-tight md:text-5xl">
            Premium Scientific Instruments, Products & Services for the Irish Market
          </p>
          <button className="mt-10 rounded bg-[#5ca2ea] px-6 py-2 text-sm font-bold uppercase tracking-wide text-white">
            Contact Us
          </button>
        </div>
      </section>

      <section className="bg-[#5ca2ea] py-4 text-center text-white">
        <h2 className="text-3xl font-black uppercase tracking-wide">Syntec Scientific</h2>
        <p className="mt-1 text-sm font-bold uppercase tracking-wide text-[#1f4f7c]">
          Syntec supplies premium scientific instruments, products & services to the Irish market
        </p>
      </section>

      <section className="bg-white/80 px-4 py-10">
        <div className="mx-auto max-w-[1240px] text-center">
          <p className="text-4xl font-light text-slate-700">
            About <span className="font-semibold text-[#4b9df0]">Us</span>
          </p>
          <p className="mx-auto mt-5 max-w-[920px] text-left text-lg leading-8 text-slate-700">
            Syntec Scientific act as a distributor for brands that are market leaders in their specific sectors. Our primary focus is on the Pathology
            sector in Ireland but we have also built up a substantial customer base in the Research, Pharmaceutical and Food Industry sectors.
          </p>
          <p className="mx-auto mt-5 max-w-[920px] text-left text-lg leading-8 text-slate-700">
            Our goal is to supply premium products into our target markets backed up by unmatched customer service levels and support.
            Syntec are continually researching new market developments and innovative new product ideas that we can bring to our customers.
          </p>
        </div>
      </section>

      <section className="bg-[#5ca2ea] py-4 text-center text-white">
        <h2 className="text-3xl font-black uppercase tracking-wide">Product Range</h2>
        <p className="mt-1 text-sm font-bold uppercase tracking-wide text-[#1f4f7c]">What we supply</p>
      </section>

      <section className="bg-[#d5e5f3] px-4 py-8">
        <div className="mx-auto grid max-w-[1240px] gap-4 md:grid-cols-3">
          <img src="/assets/images/images_misc/Misc_77.jpg" alt="Product range 1" className="h-48 w-full object-cover shadow" />
          <img src="/assets/images/images_misc/Misc_90.jpg" alt="Product range 2" className="h-48 w-full object-cover shadow" />
          <img src="/assets/images/images_misc/Misc_104.jpg" alt="Product range 3" className="h-48 w-full object-cover shadow" />
        </div>
      </section>

      <section className="bg-[#5ca2ea] py-4 text-center text-white">
        <h2 className="text-3xl font-black uppercase tracking-wide">Suppliers & Brands</h2>
        <p className="mt-1 text-sm font-bold uppercase tracking-wide text-[#1f4f7c]">
          Syntec supplies premium scientific instruments, products & services to the Irish market
        </p>
      </section>

      <section className="bg-white/80 px-4 py-10">
        <div className="mx-auto max-w-[1240px] text-center">
          <p className="text-4xl font-light text-slate-700">
            About Our <span className="font-semibold text-[#4b9df0]">Suppliers</span>
          </p>
          <p className="mx-auto mt-5 max-w-[920px] text-left text-lg leading-8 text-slate-700">
            Syntec Scientific is based in Ireland, we are a leading supplier to the Microbiology, Immunology, Histopathology and Clinical Sciences market.
            We work with market-leading brands in the developing go to market solutions and maximising their potential in the European and Irish health care markets.
          </p>
        </div>
      </section>
    </section>
  );
}
