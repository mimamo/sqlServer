USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DeleteCAbatch]    Script Date: 12/21/2015 14:05:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.DeleteCAbatch    Script Date: 4/7/98 12:49:20 PM ******/
Create Procedure [dbo].[DeleteCAbatch] @parm1 varchar ( 6), @parm2 varchar ( 6) As
select * from Batch Where
batch.Module = 'CA' and
Batch.Status in ('V', 'C', 'P') and
Batch.PerPost <= @parm1 and
Batch.PerPost <= @parm2
GO
