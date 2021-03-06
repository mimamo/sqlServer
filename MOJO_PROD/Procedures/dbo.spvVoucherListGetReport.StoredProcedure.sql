USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spvVoucherListGetReport]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spvVoucherListGetReport]

	(
		@CompanyKey int,
		@UserKey int,
		@VendorKey int,
		@Status smallint
	)

AS --Encrypt


IF @Status IS NULL
	SELECT *
	FROM
		vVoucherList (NOLOCK)
	WHERE
		CompanyKey = @CompanyKey AND
		Posted = 0 AND
		ApprovedByKey = @UserKey AND
		Status = 2
	ORDER BY
		VendorID, DueDate
ELSE
	IF @Status = 4
		IF @VendorKey IS NULL
			SELECT *
			FROM
				vVoucherList (NOLOCK)
			WHERE
				CompanyKey = @CompanyKey AND
				Posted = 1
			ORDER BY
				VendorID, DueDate
		ELSE
			SELECT *
			FROM
				vVoucherList (NOLOCK)
			WHERE
				VendorKey = @VendorKey AND
				Posted = 1
			ORDER BY
				VendorID, DueDate
	ELSE
		IF @VendorKey IS NULL
			SELECT *
			FROM
				vVoucherList (NOLOCK)
			WHERE
				CompanyKey = @CompanyKey AND
				Posted = 0 AND
				Status = @Status
			ORDER BY
				VendorID, DueDate
		ELSE
			SELECT *
			FROM
				vVoucherList (NOLOCK)
			WHERE
				CompanyKey = @CompanyKey AND
				VendorKey = @VendorKey AND
				Posted = 0 AND
				Status = @Status
			ORDER BY
				VendorID, DueDate
GO
