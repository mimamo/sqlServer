USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[x21kc_slsperquota_slsperid]    Script Date: 12/21/2015 15:43:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE proc [dbo].[x21kc_slsperquota_slsperid] @parm1 varchar (10), @parm2 varchar (6)  as
	select  * from slsperhist where
	slsperid = @parm1  
	and pernbr = @parm2
	order by  slsperid, pernbr
GO
