USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[WrkTrslHdr_TrslId_Period]    Script Date: 12/21/2015 15:37:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.WrkTrslHdr_TrslId_Period    Script Date: 4/7/98 12:45:04 PM ******/
Create Procedure [dbo].[WrkTrslHdr_TrslId_Period] @parm1 varchar(10), @parm2 varchar(6) AS
     Select * from WrkTrslHdr
     where TrslID like @parm1
     and   Period like @parm2
     Order by TrslId, Period
GO
