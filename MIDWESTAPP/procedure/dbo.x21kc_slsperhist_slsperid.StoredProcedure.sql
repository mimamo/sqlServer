USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[x21kc_slsperhist_slsperid]    Script Date: 12/21/2015 15:55:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE proc [dbo].[x21kc_slsperhist_slsperid] @parm1 varchar (10), @parm2 varchar (4)  as
	select  * from slsperhist where
	slsperid = @parm1  
	and fiscyr = @parm2
	order by  slsperid, fiscyr
GO
