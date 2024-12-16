import Header from "./Header";
import HeroSection from "./HeroSection";
import Footer from "./Footer"

function Home() {
  return (
    <div className="">
      <div className="h-full">
      <Header />
      <HeroSection />
      </div>
      {/* <div className="">
      <About />
      <Categories />
      </div> */}
      <Footer />
    </div>
  );
}

export default Home;
