USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPTDSUM_upjtfac]    Script Date: 12/21/2015 14:17:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
create procedure [dbo].[PJPTDSUM_upjtfac] @parm1 varchar (16)   as
Update PJPTDSUM
SET fac_amount = 0,
fac_units = 0
WHERE
project = @parm1
GO
