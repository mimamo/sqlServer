USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDContainer_UCC128]    Script Date: 12/21/2015 13:35:42 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[EDContainer_UCC128] @UCC128 varchar(20) AS
select * from edcontainer
where UCC128 = @UCC128
GO
