USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[proiheader1]    Script Date: 12/16/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.proiheader1    Script Date: 4/17/98 12:50:25 PM ******/
Create Procedure [dbo].[proiheader1] @rptidb smallint           ,@rptide smallint            As
Select * from roiheader
Where RI_ID Between @rptidb and @rptide
Order by RI_ID
GO
