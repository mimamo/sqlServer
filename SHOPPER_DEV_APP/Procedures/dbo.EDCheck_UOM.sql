USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDCheck_UOM]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDCheck_UOM] @UOM varchar(6), @InvtId varchar(30), @ClassId varchar(6) As

Declare @RetVal smallint
Declare @UomCount int

Select @UomCount = Count(*) From InUnit Where (FromUnit = @UOM Or ToUnit = @UOM) And InvtId In (@InvtId,'*') And ClassId In (@ClassId,'*')
If @UomCount > 0
  Begin
  Select @Retval = 0
  End
Else
  Begin
  Select @Retval = 9
End
Select @Retval
GO
