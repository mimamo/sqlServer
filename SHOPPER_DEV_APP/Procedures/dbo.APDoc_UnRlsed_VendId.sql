USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[APDoc_UnRlsed_VendId]    Script Date: 12/16/2015 15:55:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APDoc_UnRlsed_VendId    Script Date: 4/7/98 12:19:54 PM ******/
Create Procedure [dbo].[APDoc_UnRlsed_VendId] @parm1 varchar ( 15) As
Select * from APDoc where
APDoc.VendId = @parm1 and APDoc.Rlsed = 0
GO
