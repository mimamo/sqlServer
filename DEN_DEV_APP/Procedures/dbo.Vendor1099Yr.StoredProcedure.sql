USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Vendor1099Yr]    Script Date: 12/21/2015 14:06:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Vendor1099Yr    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[Vendor1099Yr] @parm1 varchar(10) as
Select * from Vendor where
Curr1099Yr = @parm1
order by Curr1099Yr, VendID
GO
