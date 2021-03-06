USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[DeleteAPBatch]    Script Date: 12/21/2015 15:49:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.DeleteAPBatch    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[DeleteAPBatch] @parm1 varchar ( 6), @parm2 varchar ( 6) As
Delete batch from Batch Where
Module = 'AP' and
Status in ('V', 'C', 'P', 'D') and
PerPost <= @parm1 and
PerPost <= @parm2
GO
