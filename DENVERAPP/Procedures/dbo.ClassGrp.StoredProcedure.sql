USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[ClassGrp]    Script Date: 12/21/2015 15:42:45 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Procedure [dbo].[ClassGrp] @parm1 varchar (15)
AS
Select *
from Customer where user6 like @parm1
 order by user6
GO
