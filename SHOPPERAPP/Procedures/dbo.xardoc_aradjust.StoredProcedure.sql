USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[xardoc_aradjust]    Script Date: 12/21/2015 16:13:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[xardoc_aradjust] @refnbr varchar(10) as
select count(*) from aradjust where
adjdrefnbr = @refnbr
GO
