USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[x21kc_Arhist_custid]    Script Date: 12/21/2015 14:18:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE proc [dbo].[x21kc_Arhist_custid] @parm1 varchar (15), @parm2 varchar (10), @parm3 varchar (4) as
	select  * from arhist where
	custid = @parm1  
	AND cpnyid = @parm2 
	AND fiscyr = @parm3
	order by  custid, cpnyid, fiscyr
GO
