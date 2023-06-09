@system BoundaryLayer begin
    w: leaf_width ~ preserve(u"cm", parameter, override)

    #TODO
    sr: stomatal_ratio => begin
        1.0
    end ~ preserve(parameter)
    scr(sr): sides_conductance_ratio => ((sr + 1)^2 / (sr^2 + 1)) ~ preserve

    # multiply by 1.4 for outdoor condition, Campbell and Norman (1998), p109
    ocr: outdoor_conductance_ratio => 1.4 ~ preserve

    u(u=wind): wind_velocity ~ track(u"m/s", min=0.1)

    dBL(w): characteristic_dimension => 0.72w ~ track(u"m")

    v: kinematic_viscosity_of_air_at_20 => 1.51e-5 ~ preserve(u"m^2/s", parameter)

    κ: thermal_diffusivity_of_air_at_20 => 21.5e-6 ~ preserve(u"m^2/s", parameter)

    Re(u, dBL, v): reynolds_number => u*dBL/v ~ track

    Nu(Re): nusselt_number => 0.60sqrt(Re) ~ track

    gh(κ, Nu, dBL, scr, ocr, P_air, Tk_air): boundary_layer_heat_conductance => begin
        g = κ * Nu / dBL
        # multiply by ratio to get the effective blc (per projected area basis), licor 6400 manual p 1-9
        g *= scr * ocr
        # including a multiplier for conversion from mm s-1 to mol m-2 s-1
        g * P_air / (u"R" * Tk_air)
    end ~ track(u"mmol/m^2/s")
    # 1.1 is the factor to convert from heat conductance to water vapor conductance, an average between still air and laminar flow (see Table 3.2, HG Jones 2014)
    
    gb(gh, P_air): boundary_layer_conductance => 0.147/0.135*gh / P_air ~ track(u"mol/m^2/s/bar" #= H2O =#)
end