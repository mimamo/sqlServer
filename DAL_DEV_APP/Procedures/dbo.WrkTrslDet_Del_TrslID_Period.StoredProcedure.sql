USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WrkTrslDet_Del_TrslID_Period]    Script Date: 12/21/2015 13:35:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.WrkTrslDet_Del_TrslID_Period    Script Date: 4/7/98 12:45:04 PM ******/
Create Procedure [dbo].[WrkTrslDet_Del_TrslID_Period] @parm1 varchar(10), @parm2 varchar(6) AS
     Delete from WrkTrslDet
     Where TrslId = @parm1
     and   Period = @parm2
GO
