USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDInunit_ToUOMs]    Script Date: 12/21/2015 14:17:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
-- only used by a PV
Create Proc [dbo].[EDInunit_ToUOMs] @UOM varchar(6)As
Select Distinct ToUnit From InUnit Where ToUnit Like @UOM Order By ToUnit
GO
