{ pkgs, ... }:

let
  inherit (pkgs) fetchurl;
in
{
  default = {
    ferrite-core = fetchurl {
      url = "https://cdn.modrinth.com/data/uXXizFIs/versions/x7kQWVju/ferritecore-7.0.3-neoforge.jar";
      sha512 = "19af89a2075bb10a63884fa853ebf84b02c79dc3242430ecdad056fd764fdcde367a7303276b329df01b0736e2ef264c5d80c7dc92c6aebd244f556a230bb417";
    };
    lithium = fetchurl {
      url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/RXHf27Wv/lithium-neoforge-0.15.3%2Bmc1.21.1.jar";
      sha512 = "65568e6c7e41684ad20e58db8766813840c0c8406eed9edc3f7a2514da7250ac46bde2bfb0936984cc5516c2782f86387ad0ed3d1b804b8bdddc7f7048759df4";
    };
    no-chat-reports = fetchurl {
      url = "https://cdn.modrinth.com/data/qQyHxfxd/versions/ZV8eL55E/NoChatReports-NEOFORGE-1.21.1-v2.9.1.jar";
      sha512 = "292a3623b5addb17e9f15681a4f2534562e9882ef809e504f49da4778fafc12e21a71995b5d05554d435201f401ace1e86af50e6e26f6ce9d203a5896a1ece21";
    };
    scalable-lux = fetchurl {
      url = "https://cdn.modrinth.com/data/Ps1zyz6x/versions/j10HNoNf/ScalableLux-0.1.0.1%2Bneoforge.1cb1e91-all.jar";
      sha512 = "9378b6a70eca81b018121c01a1467c16245ee3f0bb3cfeece6e9045508ae18834256aed4a72d045df9fc3feca94f006518788260e47094173fa64c39d8450223";
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

  car = fetchurl {
    url = "https://cdn.modrinth.com/data/DCPUF5Rv/versions/pdJf8Ces/car-neoforge-1.21.1-1.0.46.jar";
    sha512 = "8cdf98c82f58c0175c28016c7e43ce1af388be784c4ddab8b9d74982bf79e476261737aef65527469b23d860cf7c411435a0d1505df9b5937a4c2dc3053dcf50";
  };

  bblcore = fetchurl {
    url = "https://cdn.modrinth.com/data/tfpHINm8/versions/BQtVuunR/bblcore-1.21-1.3.20.jar";
    sha512 = "e1a52287267f3c8920d4a3fad368e5e7558b2a3b1b698b8f2b0bd9302cce2fbbc71b18cd2d33186de73b38ca58814d527e0d3aace3fedbf525975f5a3ade0eaf";
  };

  many-more-ores-and-crafts = fetchurl {
    url = "https://cdn.modrinth.com/data/6kAZrZHA/versions/Ai3xBhul/many_more_ores_and_crafts-NeoForge-1.21.1-1.1.2.jar";
    sha512 = "0d32a6379ac994a5264cc10a25d84314717b88344d82bf84d174faafd05d8e051becfc1733211ab1e1db2d1dd3d8520a63b35791843351a5256d177575df125b";
  };

  jetpack = fetchurl {
    url = "https://cdn.modrinth.com/data/e2At55pl/versions/zEF9SUdj/jetpack-1.0.0-neoforge-1.21.1.jar";
    sha512 = "8c75a7c60e309473333d137c4e73c90ee529df6df0ba92866803b635c8128b1f428b529582ac5121332bc14b7ccf15a1d9c522264c2336b208e5e3255955fb7e";
  };

  ciggycraft = fetchurl {
    url = "https://cdn.modrinth.com/data/EqIpFduf/versions/9FEo8baS/ciggycraft-1.0.3.jar";
    sha512 = "ef0951d6cb7ab82f8faa47d428bc9ceba51a5c15d479a75a1ffc689e909d02497ec7997a83010f1f3b2fd6ec2a19f3c2609d66c230ce0fe7ab9a1714ec20139e";
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
