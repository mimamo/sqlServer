USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SIBuyer_All]    Script Date: 12/16/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.SIBuyer_All    Script Date: 12/17/97 10:49:00 AM ******/
Create Procedure [dbo].[SIBuyer_All] @Parm1 Varchar(47) as
Select * from SIBuyer WHERE Buyer LIKE @Parm1 Order by Buyer
GO
