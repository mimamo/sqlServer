USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ItemXRef_InvtID_Type_Ent_AltId]    Script Date: 12/21/2015 15:36:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[ItemXRef_InvtID_Type_Ent_AltId] @Parm1 varchar ( 30), @Parm2 varchar ( 1), @Parm3 varchar ( 15), @Parm4 varchar (30) As
	Select * from ItemXRef
             Where InvtID         = @Parm1
               And AltIDType   Like @Parm2
               And EntityID    Like @Parm3
               And AlternateId Like @Parm4
GO
