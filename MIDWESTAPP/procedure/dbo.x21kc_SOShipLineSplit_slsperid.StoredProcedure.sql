USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[x21kc_SOShipLineSplit_slsperid]    Script Date: 12/21/2015 15:55:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE proc [dbo].[x21kc_SOShipLineSplit_slsperid] @parm1 varchar (10), @parm2 varchar (10) , @parm3 varchar(15), @parm4 varchar(5) as
	select  * from SOShipLineSplit where
	slsperid = @parm1
	and cpnyid = @parm2  
	and shipperid = @parm3
	and lineref = @parm4
	order by    slsperid
GO
