USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PJPTDSUM_upjtfac]    Script Date: 12/16/2015 15:55:28 ******/
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
