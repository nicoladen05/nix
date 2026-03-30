{ pkgs, ... }:

let
  inherit (pkgs) fetchurl;
in
{
  default = {
    fabric-api = fetchurl {
      url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/yGAe1owa/fabric-api-0.116.9%2B1.21.1.jar";
      sha512 = "e643876079b950aef9aad3eee8d27046305895e8d0f595f7f95010839adeaa25c55a6dc8624ccfba1201194d6598fcbc11f23a7a553ccefbb8c0ceacf388bb79";
    };
    ferrite-core = fetchurl {
      url = "https://cdn.modrinth.com/data/uXXizFIs/versions/sOzRw3CG/ferritecore-7.0.3-fabric.jar";
      sha512 = "3ad31620fac4ff44327dc7dedbe162b2d978f3f246dc16255a6e400ce9592a0d326fe36a626f3c1bf30a11f813093cbb4dcc107af039cff724d0cdf648541fdf";
    };
    lithium = fetchurl {
      url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/XQJtuOTA/lithium-fabric-0.15.3%2Bmc1.21.1.jar";
      sha512 = "8c576d519121b0c2521101d2209eccd85d560b097fcb847aa54c51cd0d3f3947676f01c8d99913f514487c8e0972a1cf5f3da0c9ef0ec9bacdf2baeb4eb7d1a7";
    };
    no-chat-reports = fetchurl {
      url = "https://cdn.modrinth.com/data/qQyHxfxd/versions/D8K0KJXM/NoChatReports-FABRIC-1.21.1-v2.9.1.jar";
      sha512 = "23bb4a8a6a3f7071281cf97560e12f37e1f5f638a156e3fcb92a50ff0091f1fcfa3e090e7745e4b1175e7c2c784e38d73536a1044db1bf225a182fab758a5a29";
    };
    scalable-lux = fetchurl {
      url = "https://cdn.modrinth.com/data/Ps1zyz6x/versions/Yx1tgJMI/ScalableLux-0.1.0.1%2Bfabric.d0d58ab-all.jar";
      sha512 = "bbfe02184c3bf3b0da28175574a5a236ce7c9acc00069addd69770857f2ac572924893f3eb033bbbc965afa9779c7a7f8fc54168f9e90481a40de92f6ee3645f";
    };
  };

  bbl-casting = fetchurl {
    url = "https://cdn.modrinth.com/data/YadXQ97f/versions/DQ0eiH2E/casting-1.21.1-2.3.9.jar";
    sha512 = "8885ebfe7941830c71d1b1fbbc36a0213a0b55f46f5f8af4af0b45e301debee692b0343d7322c783426c208fcb340a7e08bb5c1c2642d12e8e1cc47ab4e33ca2";
  };

  ultimate-plane-mod = fetchurl {
    url = "https://cdn.modrinth.com/data/qLDTK94S/versions/r9cNkxGw/plane-neoforge-1.21.1-1.5.5.jar";
    sha512 = "26da044f9b39af122a0ae2a16c57606b7421781c581da317227b9a4b7d3fd4019aa44476416f09e7804c860c0fb91a8283b3780ff88e86240d2ba10ce0787a12";
  };

  building = {
    axiom = fetchurl {
      url = "https://cdn.modrinth.com/data/N6n5dqoA/versions/M0Jr2ivY/Axiom-5.2.1-for-MC1.21.11.jar";
      sha512 = "00be4c7e6652d8f36855b222effa19a23a532659da932b4321f4f786f169be3d98977e3d4271deb6b415f4692eb87d9a8fd78295a55bbe887771302e64bb1c58";
    };
    world-edit = fetchurl {
      url = "https://cdn.modrinth.com/data/1u6JkXh5/versions/D4snyuU8/worldedit-mod-7.4.0-beta-02.jar";
      sha512 = "887c1f9479ef0d06714c4f842f49568a209f57cc29b21b59373ff8ae5702f65c45b3f5caa442a2cc1b9f0242f93f46706d67b808c30c054eae1e142bc1259fb3";
    };
  };

  cheaty = {
    falling-tree = fetchurl {
      url = "https://cdn.modrinth.com/data/Fb4jn8m6/versions/s7RpQ7ah/FallingTree-1.21.11-1.21.11.2.jar";
      sha512 = "4414f5850297c1b31ab1150d71d7dde44e2132fdaef4b286df8785be9f975e98c45317bba7a22fb1612f287dfebe875b7b69444a151a64cb64dd38c4f7b433f9";
    };
    infinite-trade = fetchurl {
      url = "https://cdn.modrinth.com/data/U3eoZT3o/versions/QmTnAQac/infinitetrading-1.21.11-4.6.jar";
      sha512 = "03dd37e306b71c0588d89b395f4862e80deedaca4facbda721052d346e56f5385f88bd56382fc5cbeb3a91488f2dd33446612c32392b677f9a1f057edb2d78e8";
    };
    collective = fetchurl {
      url = "https://cdn.modrinth.com/data/e0M1UDsY/versions/T8rv7kwo/collective-1.21.11-8.13.jar";
      sha512 = "af145a48ac89346c7b1ffa8c44400a91a9908e4d1df0f6f1a603ff045b1fd82d9aa041aea27a682c196b266c0daf84cb5b7b8d83b07ee53e2bc1a5c210d19a1b";
    };
  };
}
