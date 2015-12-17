USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Update_AP_PRTran]    Script Date: 12/16/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[Update_AP_PRTran] @parm1 varchar(10), @parm2 varchar(10) As
update pr
	set APBatch = "", APRefnbr = "", APLineID = 0
	from prtran pr
	where 	pr.APBatch = @parm1 and
		pr.APRefnbr = @parm2
GO
