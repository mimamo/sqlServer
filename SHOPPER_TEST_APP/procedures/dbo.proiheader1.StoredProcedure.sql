USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[proiheader1]    Script Date: 12/21/2015 16:07:17 ******/
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
