USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDItemXRef_LookUpEntity]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[EDItemXRef_LookUpEntity] @Parm1 varchar(1), @Parm2 varchar(30), @Parm3 varchar(15) As
Select A.InvtId From ItemXRef A, Inventory B Where A.AltIdType = @Parm1 And A.AlternateId = @Parm2
And A.EntityId = @Parm3 And A.InvtId = B.InvtId And B.TranStatusCode IN ('AC','NP','OH')
GO
