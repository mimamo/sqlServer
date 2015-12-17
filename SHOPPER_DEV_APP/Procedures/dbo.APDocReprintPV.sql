USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[APDocReprintPV]    Script Date: 12/16/2015 15:55:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APDocReprintPV    Script Date: 4/7/98 12:19:54 PM ******/
Create Procedure [dbo].[APDocReprintPV] @parm1 varchar(10), @parm2 varchar(10) As
Select * from APCheck
Where BatNbr = @parm1 and
CheckNbr LIKE @parm1
Order by CheckNbr
GO
