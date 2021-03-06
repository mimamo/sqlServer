USE [DENVERAPP]
GO
/****** Object:  StoredProcedure [dbo].[UpdateProdGloss]    Script Date: 12/21/2015 15:43:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Dan Bertram
-- Create date: 4.4.2013
-- Description:	SPROC to update the Product glosery and email Bonnie Ladwig
-- =============================================

CREATE PROCEDURE [dbo].[UpdateProdGloss] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO OPENQUERY ([xRHSQL.butler], 'SELECT type, clientID, ClientName, clientStatus, ProdID, Product, ProductStatus, ProductGroup FROM butler.client_product_glossary_changes')
SELECT [type], clientID, ClientName, clientStatus, ProdID, Product, ProductStatus, ProductGroup
FROM DENVERAPP..xCPG
WHERE prodID not in (SELECT * FROM OPENQUERY([xRHSQL.butler], 'SELECT ProdID FROM butler.client_product_glossary_changes'))
END
GO
