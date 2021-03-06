USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDItemXRef_LookUp]    Script Date: 12/21/2015 14:34:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDItemXRef_LookUp] @Parm1 varchar(1), @Parm2 varchar(30), @Parm3 varchar(10) As
Select A.InvtId From ItemXRef A, Inventory B Where A.AltIdType = @Parm1 And A.AlternateId = @Parm2
And A.InvtId = B.InvtId And B.TranStatusCode IN ('AC','NP','OH')
GO
