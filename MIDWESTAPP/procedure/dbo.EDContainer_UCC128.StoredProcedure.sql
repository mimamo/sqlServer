USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_UCC128]    Script Date: 12/21/2015 15:55:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDContainer_UCC128] @UCC128 varchar(20) AS
select * from edcontainer
where UCC128 = @UCC128
GO
