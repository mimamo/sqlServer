USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[roiextra]    Script Date: 12/16/2015 15:55:31 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.roiextra    Script Date: 4/17/98 12:50:25 PM ******/
/****** Object:  Stored Procedure dbo.roiextra    Script Date: 4/7/98 12:56:04 PM ******/
Create Procedure [dbo].[roiextra] @rptriid smallint            As
Select * from rptextra
Where RI_ID = @rptriid
Order by RI_ID
GO
