USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[pjactrol_spk11]    Script Date: 12/21/2015 13:44:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[pjactrol_spk11] @parm1 varchar (4), @parm2 varchar (16)   as
SELECT
        r.fsyear_num,
        r.project,
        r.acct,
        r.amount_01,r.amount_02,r.amount_03,
        r.amount_04,r.amount_05,r.amount_06,
        r.amount_07,r.amount_08,r.amount_09,
        r.amount_10,r.amount_11,r.amount_12,
        r.amount_13,r.amount_14,r.amount_15,
        r.amount_bf,
        r.units_01,r.units_02,r.units_03,
        r.units_04,r.units_05,r.units_06,
        r.units_07,r.units_08,r.units_09,
        r.units_10,r.units_11,r.units_12,
        r.units_13,r.units_14,r.units_15,
        r.units_bf,
        p.bf_values_switch
FROM
        pjactrol r, pjproj p
WHERE
        r.project = p.project and
        r.fsyear_num = @parm1 and
        r.project like @parm2 and
        p.bf_values_switch = 'Y'
ORDER BY
        r.project
GO
