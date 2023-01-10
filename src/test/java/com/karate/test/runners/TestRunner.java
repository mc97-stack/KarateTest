package com.karate.test.runners;

import com.intuit.karate.junit5.Karate;
import org.junit.jupiter.api.Test;

public class TestRunner {

    @Karate.Test
    Karate startServer() {
        Karate.run();
        return Karate.run("classpath:com/karate/test/common/mockserver", "classpath:com/karate/test/tests/server");
    }

    @Karate.Test
    Karate runSmokeTests() {
        Karate.run();
        return Karate.run("classpath:com/karate/test/common/mockserver", "classpath:com/karate/test/tests/smoke");
    }

    @Karate.Test
    Karate runSystemTests() {
        return Karate.run("classpath:com/karate/test/common/mockserver", "classpath:com/karate/test/tests/system");
    }

}
