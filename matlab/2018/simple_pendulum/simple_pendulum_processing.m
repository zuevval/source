%simple_pendulum_processing
figure
hold on
plot(q_0)
plot(q_minus_45)
plot(q_minus_80)
legend('q0=0','q0=-45 deg', 'q0=45 deg')
title('angle q(t) (free ocsillations)')
figure
hold on
plot(q_0.data,w_0.data)
plot(q_minus_45.data,w_minus_45.data)
plot(q_minus_80.data,w_minus_80.data)
plot(q_45.data,w_45.data)
plot(q_80.data,w_80.data)
legend('0 deg','-45 deg','-80 deg','45 deg','80 deg')
title('phase - angular velocity diagrams (different starting angles)')

figure
hold on
plot(q_dmp_2_5e_minus_5);
plot(w_dmp_2_5e_minus_5);
legend('q(t)','w(t)')
title('angle q(t), angular velocity w(t) (damping coefficient 2.5\cdot10^{-5})')
figure
hold on
plot(q_dmp_2_5e_minus_5.data,w_dmp_2_5e_minus_5.data);
plot(q_dmp_q0_minus_300.data,w_dmp_q0_minus_300.data);
plot(q_dmp_q0_minus_100.data,w_dmp_q0_minus_100.data);
plot(q_dmp_q0_minus_50.data,w_dmp_q0_minus_50.data);
plot(q_dmp_q0_20.data,w_dmp_q0_20.data);
legend('q0=0','q0=-300 deg','q0=-100 deg','q0=-50 deg','q0=20 deg')
title('phase - angular velocity diagram (damping coefficient 2.5\cdot10^{-5})')

figure
hold on
plot(q_forced);
plot(w_forced);
legend('q(t)','w(t)')
title('q(t), w(t) (damping coeff. 2.5\cdot10^{-5}, force F(t)=0.02sin(t))')

figure
hold on
plot(q_forced.data,w_forced.data);
title('phase - angular velocity diagram (damping + external force)')