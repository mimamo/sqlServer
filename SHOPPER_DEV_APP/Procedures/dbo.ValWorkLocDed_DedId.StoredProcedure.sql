USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ValWorkLocDed_DedId]    Script Date: 12/21/2015 14:34:40 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[ValWorkLocDed_DedId] @parm1 varchar ( 10) as
       Select * from ValWorkLocDed
           where DedId  LIKE  @parm1
           order by DedId
GO
