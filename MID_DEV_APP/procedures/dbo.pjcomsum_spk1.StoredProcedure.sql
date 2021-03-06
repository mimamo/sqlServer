USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pjcomsum_spk1]    Script Date: 12/21/2015 14:17:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjcomsum_spk1] @parm1 varchar (4)   as
SELECT
s.fsyear_num,
s.project,
s.pjt_entity,
s.acct,
s.amount_01,s.amount_02,s.amount_03,
s.amount_04,s.amount_05,s.amount_06,
s.amount_07,s.amount_08,s.amount_09,
s.amount_10,s.amount_11,s.amount_12,
s.amount_13,s.amount_14,s.amount_15,
s.amount_bf,
s.units_01,s.units_02,s.units_03,
s.units_04,s.units_05,s.units_06,
s.units_07,s.units_08,s.units_09,
s.units_10,s.units_11,s.units_12,
s.units_13,s.units_14,s.units_15,
s.units_bf,
p.bf_values_switch
FROM
pjcomsum s, pjproj p
WHERE
s.project = p.project and
s.fsyear_num = @parm1 and
p.bf_values_switch = 'Y'
ORDER BY
s.project, s.pjt_entity
GO
