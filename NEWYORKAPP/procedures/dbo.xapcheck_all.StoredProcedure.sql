USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[xapcheck_all]    Script Date: 12/21/2015 16:01:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[xapcheck_all] @BatNbr varchar(10) AS
Select * from XAPCheck where BatNbr like @BatNbr and Printed = 1 order by BatNbr
GO
