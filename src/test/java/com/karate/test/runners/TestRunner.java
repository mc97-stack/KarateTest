package com.karate.test.runners;

import com.intuit.karate.junit5.Karate;
import org.junit.jupiter.api.Test;

public class TestRunner {

    @Karate.Test
    Karate runTests() {
        return Karate.run("classpath:com/karate/test/common/mockserver", "classpath:com/karate/test/tests");
    }

}
