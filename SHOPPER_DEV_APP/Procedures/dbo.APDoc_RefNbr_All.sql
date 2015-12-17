USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[APDoc_RefNbr_All]    Script Date: 12/16/2015 15:55:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APDoc_RefNbr_All    Script Date: 4/7/98 12:19:54 PM ******/
Create Procedure [dbo].[APDoc_RefNbr_All] @parm1 varchar(10), @parm2 varchar ( 10) as
Select * From APDoc
Where CpnyId Like @parm1 and RefNbr LIKE @parm2
Order by RefNbr DESC
GO
