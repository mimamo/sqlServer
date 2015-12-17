USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DeductContrib_DedId_Delete]    Script Date: 12/16/2015 15:55:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[DeductContrib_DedId_Delete] @parm1 varchar ( 10), @parm2 varchar (4) as
       if NOT exists (select DedId from Deduction where DedId = @parm1 and CalYr <> @parm2 and Dedtype = 'W')
           Delete DeductContrib Where DedId = @parm1
GO
