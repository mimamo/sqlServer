USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ValWorkLocDed_DedId]    Script Date: 12/21/2015 16:13:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[ValWorkLocDed_DedId] @parm1 varchar ( 10) as
       Select * from ValWorkLocDed
           where DedId  LIKE  @parm1
           order by DedId
GO
