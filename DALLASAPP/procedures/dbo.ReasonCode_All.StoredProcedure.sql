USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[ReasonCode_All]    Script Date: 12/21/2015 13:45:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ReasonCode_All    Script Date: 4/17/98 10:58:19 AM ******/
/****** Object:  Stored Procedure dbo.ReasonCode_All    Script Date: 4/16/98 7:41:53 PM ******/
Create Proc [dbo].[ReasonCode_All] @parm1 varchar ( 6) as
        Select * from ReasonCode where ReasonCd like @parm1
                order by ReasonCd
GO
