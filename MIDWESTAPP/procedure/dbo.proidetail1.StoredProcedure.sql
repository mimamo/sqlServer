USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[proidetail1]    Script Date: 12/21/2015 15:55:40 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.proidetail1    Script Date: 4/17/98 12:50:25 PM ******/
Create Procedure [dbo].[proidetail1] @rptidb smallint           , @rptide smallint           , @lb smallint           , @le smallint            As
Select * from roidetail
Where RI_ID Between @rptidb and @rptide and
linenbr Between @lb and @le
Order by RI_ID, linenbr
GO
