@system Dormancy begin

    T_dorm: temperature_threshold => 5.94915 ~ preserve(parameter, u"°C")

    Rc: chilling_requirement => begin
        -100
        #-149.549
    end ~ preserve(parameter, u"K*d")

    Rf: forcing_requirement => 100 ~ preserve(parameter, u"K*d")

    dormant(WF) => begin
        WF == 0u"kg/ha"
    end ~ flag

    DD(T_air, T_dorm): dormant_degrees => (T_air - T_dorm) ~ track(when=dormant, u"K")

    # incorporate effect of day length for chilling requirement
    dC(DD) ~ track(max = 0, u"K")
    C(dC):  chilling_accumulated ~ accumulate(when=!chilled, reset=senescent, u"K*hr")

    chilled(C, Rc) => (C <= Rc) ~ flag

    dF(DD) ~ track(min = 0, u"K")
    F(dF):  forcing_accumulated  ~ accumulate(when=chilled, reset=senescent, u"K*hr")
end