USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[chkstub_all]    Script Date: 12/21/2015 15:36:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[chkstub_all] @parm1 As char(10)
AS	
		Select * from PRDoc 
			where DocType = 'CK' 
			and ChkNbr like @parm1 
			order by ChkNbr
GO
