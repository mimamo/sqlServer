USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[APDoc_OneTime_Delete]    Script Date: 12/21/2015 14:05:55 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APDoc_OneTime_Delete    Script Date: 4/7/98 12:19:54 PM ******/
Create Procedure [dbo].[APDoc_OneTime_Delete] @parm1 varchar ( 255), @parm2 varchar ( 255), @parm3 varchar ( 255) as
Select * from APDoc where APDoc.VendID = @parm1 and
APDoc.PerEnt <= @parm2 and APDoc.PerClosed <= @parm3 and APDoc.PerClosed <> ' ' order by
APDoc.RefNbr
GO
