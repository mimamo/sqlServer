USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PIDetail_NbrAdjustments]    Script Date: 12/21/2015 13:35:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.PIDetail_NbrAdjustments    Script Date: 4/17/98 10:58:19 AM ******/
Create Procedure [dbo].[PIDetail_NbrAdjustments] @parm1 VarChar(10) As
select Count(*) from pidetail where piid = @parm1 and bookqty <> physqty and status = 'E'
GO
